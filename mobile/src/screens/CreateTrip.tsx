import { DatePicker } from '../components/DatePicker';
import React, { useState } from 'react';
import { KeyboardAvoidingView, Platform, ScrollView, Text, View } from 'react-native';
import { useApp, useResource } from '../store';
import { Button, C, ErrorBox, Field, Header, Pill, S } from '../ui';
import { durationBetween, errorText, positiveNumber, today } from '../lib';
import type { Trip, Template } from '../types';
import type { Route } from '../navigation';
export function CreateTripScreen({
  route,
  back,
  created,
}: {
  route: Extract<Route, { name: 'create' }>;
  back: () => void;
  created: (trip: Trip) => void;
}) {
  const { request } = useApp();
  const [destination, setDestination] = useState(route.destination || '');
  const [start, setStart] = useState(today());
  const [end, setEnd] = useState(() => {
    const d = new Date(today() + 'T12:00:00');
    d.setDate(d.getDate() + (route.duration || 3) - 1);
    return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
  });
  const [people, setPeople] = useState('2');
  const [budget, setBudget] = useState(String(route.budget || 4500000));
  const [mode, setMode] = useState<'MANUAL' | 'AI' | 'TEMPLATE'>(
    route.templateId ? 'TEMPLATE' : 'AI',
  );
  const [template, setTemplate] = useState(route.templateId);
  const [style, setStyle] = useState('Thư giãn');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const patterns = useResource(() => request<Template[]>('/trip-templates'), [request]);
  const submit = async () => {
    setError('');
    setBusy(true);
    try {
      if (!destination.trim()) throw new Error('Bạn muốn đi đâu? Nhập một điểm đến nhé.');
      const duration = durationBetween(start, end);
      const travelers = positiveNumber(people, 'Số người');
      if (!Number.isInteger(travelers) || travelers > 100)
        throw new Error('Số người cần là số nguyên từ 1 đến 100.');
      if (mode === 'TEMPLATE' && !template) throw new Error('Chọn một lịch trình mẫu.');
      const trip = await request<Trip>('/trips', 'POST', {
        destination: destination.trim(),
        startDate: start,
        endDate: end,
        duration,
        travelerCount: travelers,
        totalBudget: positiveNumber(budget, 'Ngân sách', true),
        planningMode: mode,
        ...(mode === 'TEMPLATE' ? { templateId: template } : {}),
        ...(mode === 'AI' ? { travelStyle: style, preferences: [style] } : {}),
      });
      created(trip);
    } catch (e) {
      setError(errorText(e));
    } finally {
      setBusy(false);
    }
  };
  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
    >
      <Header title="Hành trình mới" back={back} />
      <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={S.page}>
        <View style={{ gap: 10 }}>
          <Text style={S.label}>BẮT ĐẦU BẰNG MỘT ĐIỂM ĐẾN</Text>
          <Text style={S.title}>Chuyến đi này,{'\n'}là của riêng bạn.</Text>
          <Text style={S.body}>Một vài điều nhỏ để lên kế hoạch thật vừa vặn.</Text>
        </View>
        <Field
          label="Điểm đến"
          value={destination}
          onChangeText={setDestination}
          placeholder="Đà Nẵng, Đà Lạt, Hà Nội…"
        />
        <View style={[S.row, { alignItems: 'flex-start' }]}>
          <View style={{ flex: 1 }}>
            <DatePicker
              label="Ngày đi"
              value={start}
              onChange={(value) => {
                setStart(value);
                if (end < value) setEnd(value);
              }}
            />
          </View>
          <View style={{ flex: 1 }}>
            <DatePicker label="Ngày về" value={end} onChange={setEnd} minimum={start} />
          </View>
        </View>
        <View style={S.row}>
          <View style={{ flex: 1 }}>
            <Field
              label="Số người"
              value={people}
              onChangeText={setPeople}
              keyboardType="number-pad"
            />
          </View>
          <View style={{ flex: 2 }}>
            <Field
              label="Ngân sách cả chuyến (VNĐ)"
              value={budget}
              onChangeText={setBudget}
              keyboardType="number-pad"
            />
          </View>
        </View>
        <View style={{ gap: 12 }}>
          <Text style={S.heading}>Lên kế hoạch theo cách nào?</Text>
          {(
            [
              {
                id: 'AI',
                icon: 'sparkles',
                title: 'Để AI gợi ý',
                text: 'Cá nhân hóa theo sở thích và ngân sách.',
              },
              {
                id: 'MANUAL',
                icon: 'create-outline',
                title: 'Tự viết hành trình',
                text: 'Từng điểm đến, từng khoảnh khắc bạn chọn.',
              },
              {
                id: 'TEMPLATE',
                icon: 'albums-outline',
                title: 'Bắt đầu từ một mẫu',
                text: 'Một chút cảm hứng, rồi thêm dấu ấn riêng.',
              },
            ] as const
          ).map((m) => (
            <Button
              key={m.id}
              icon={m.icon}
              secondary={mode !== m.id}
              onPress={() => setMode(m.id)}
            >
              {m.title}
            </Button>
          ))}
        </View>
        {mode === 'AI' && (
          <View style={{ gap: 10 }}>
            <Text style={S.body}>Phong cách chuyến đi</Text>
            <View style={[S.row, { flexWrap: 'wrap' }]}>
              {['Thư giãn', 'Khám phá', 'Ẩm thực', 'Văn hóa'].map((s) => (
                <Pill key={s} selected={style === s} onPress={() => setStyle(s)}>
                  {s}
                </Pill>
              ))}
            </View>
          </View>
        )}
        {mode === 'TEMPLATE' && (
          <View style={{ gap: 10 }}>
            <ErrorBox message={patterns.error} retry={patterns.reload} />
            {patterns.data?.map((t) => (
              <Pill
                key={t.id}
                selected={template === t.id}
                onPress={() => {
                  setTemplate(t.id);
                  setDestination(t.destination);
                  setBudget(String(t.estimatedBudget));
                  const last = new Date(`${start}T12:00:00`);
                  last.setDate(last.getDate() + t.duration - 1);
                  setEnd(
                    `${last.getFullYear()}-${String(last.getMonth() + 1).padStart(2, '0')}-${String(last.getDate()).padStart(2, '0')}`,
                  );
                }}
              >{`${t.title} · ${t.duration} ngày`}</Pill>
            ))}
          </View>
        )}
        <ErrorBox message={error} />
        <Button icon="arrow-forward" busy={busy} onPress={submit}>
          {mode === 'AI' ? 'Tạo hành trình cùng AI' : 'Tạo chuyến đi'}
        </Button>
        {busy && (
          <Text style={[S.body, { textAlign: 'center' }]}>
            AI có thể cần một chút thời gian để lên lịch trình…
          </Text>
        )}
      </ScrollView>
    </KeyboardAvoidingView>
  );
}
