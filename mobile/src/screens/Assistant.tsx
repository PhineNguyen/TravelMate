import React, { useEffect, useRef, useState } from 'react';
import {
  KeyboardAvoidingView,
  Platform,
  Pressable,
  ScrollView,
  Text,
  TextInput,
  View,
} from 'react-native';
import { useApp, useResource } from '../store';
import { Button, C, Empty, ErrorBox, Icon, Loading, Pill, S } from '../ui';
import type { Conversation, Message, Trip } from '../types';
import { errorText } from '../lib';
export function AssistantScreen({
  initialTrip,
  createTrip,
}: {
  initialTrip?: Trip;
  createTrip: () => void;
}) {
  const { request, session } = useApp();
  const trips = useResource(() => request<Trip[]>('/trips'), [request]);
  const [tripId, setTripId] = useState<number | undefined>(initialTrip?.id);
  useEffect(() => {
    if (initialTrip) setTripId(initialTrip.id);
  }, [initialTrip?.id]);
  useEffect(() => {
    if (!tripId && trips.data?.length) setTripId(trips.data[0].id);
  }, [trips.data, tripId]);
  const history = useResource(
    async () => (tripId ? request<Conversation[]>(`/ai-conversations/trip/${tripId}`) : []),
    [request, tripId],
  );
  const [draft, setDraft] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const [pending, setPending] = useState('');
  const scroll = useRef<ScrollView>(null);
  const conv = history.data?.find((c) => c.tripId === tripId);
  const messages = conv?.messages || [];
  const send = async (text = draft) => {
    if (busy || history.loading || !tripId || !text.trim()) return;
    setBusy(true);
    setError('');
    setPending(text.trim());
    try {
      const conversation =
        conv ||
        (await request<Conversation>('/ai-conversations', 'POST', {
          userId: session!.user.id,
          tripId,
          sessionTitle: 'Bạn đồng hành của tôi',
        }));
      if (!conv) history.setData([{ ...conversation, messages: [] }]);
      await request<Message>('/ai-messages/send', 'POST', {
        conversationId: conversation.id,
        content: text.trim(),
      });
      setDraft('');
      await history.reload();
    } catch (e) {
      setError(errorText(e));
      setDraft(text);
    } finally {
      setBusy(false);
      setPending('');
    }
  };
  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
    >
      <View style={{ padding: 24, paddingBottom: 16, gap: 16 }}>
        <View style={S.between}>
          <View style={{ gap: 7 }}>
            <Text style={S.label}>LUÔN CÓ MỘT NGƯỜI BẠN</Text>
            <Text style={S.title}>TravelMate AI.</Text>
          </View>
          <View style={{ padding: 15, borderRadius: 22, backgroundColor: C.lime }}>
            <Icon name="sparkles" color={C.green} size={26} />
          </View>
        </View>
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={{ gap: 8 }}
        >
          {trips.data?.map((t) => (
            <Pill
              key={t.id}
              selected={tripId === t.id}
              onPress={() => {
                if (!busy) {
                  setTripId(t.id);
                  setError('');
                  setDraft('');
                }
              }}
            >
              {t.destination}
            </Pill>
          ))}
        </ScrollView>
        <ErrorBox message={trips.error} retry={trips.reload} />
      </View>
      <ScrollView
        ref={scroll}
        contentContainerStyle={{ padding: 24, paddingTop: 4, gap: 18, flexGrow: 1 }}
        onContentSizeChange={() => {
          if (messages.length) scroll.current?.scrollToEnd({ animated: true });
        }}
      >
        {trips.loading || history.loading ? (
          <Loading />
        ) : !tripId ? (
          <Empty
            icon="sparkles-outline"
            title="Mình sẽ đi đâu nhỉ?"
            text="Tạo một chuyến đi để AI có thể giúp bạn lên kế hoạch phù hợp."
            action="Tạo chuyến đi"
            onPress={createTrip}
          />
        ) : !messages.length ? (
          <View style={{ paddingTop: 25, gap: 24 }}>
            <Text style={[S.title, { fontSize: 29, lineHeight: 38 }]}>
              Một người bạn biết đường.{'\n'}Và hiểu bạn.
            </Text>
            <Text style={S.body}>
              Hỏi mình về điểm đến, món ngon hay cách sắp xếp một ngày thật đáng nhớ.
            </Text>
            {[
              'Gợi ý một ngày khám phá thật thư giãn',
              'Món ngon địa phương nào không nên bỏ lỡ?',
              'Giúp mình tối ưu ngân sách chuyến đi',
            ].map((q) => (
              <Pressable
                key={q}
                onPress={() => send(q)}
                disabled={busy}
                style={[S.card, S.between, { padding: 16 }]}
              >
                <Text style={[S.body, { flex: 1, color: C.ink, fontSize: 13 }]}>{q}</Text>
                <Icon name="arrow-up-outline" size={17} />
              </Pressable>
            ))}
          </View>
        ) : (
          messages.map((m) => (
            <View
              key={m.id}
              style={{
                alignSelf: m.senderType === 'USER' ? 'flex-end' : 'flex-start',
                maxWidth: '90%',
                gap: 7,
              }}
            >
              {m.senderType === 'AI' && (
                <Text style={[S.label, { fontSize: 9, color: C.green }]}>✦ TRAVELMATE AI</Text>
              )}
              <View
                style={{
                  padding: 17,
                  borderRadius: 20,
                  borderBottomRightRadius: m.senderType === 'USER' ? 5 : 20,
                  borderTopLeftRadius: m.senderType === 'AI' ? 5 : 20,
                  backgroundColor: m.senderType === 'USER' ? C.green : C.white,
                  borderWidth: m.senderType === 'AI' ? 1 : 0,
                  borderColor: C.line,
                }}
              >
                <Text
                  selectable
                  style={[
                    S.body,
                    { color: m.senderType === 'USER' ? C.white : C.ink, lineHeight: 23 },
                  ]}
                >
                  {m.content}
                </Text>
              </View>
            </View>
          ))
        )}
        {pending && (
          <View style={{ gap: 14 }}>
            <View
              style={{
                alignSelf: 'flex-end',
                maxWidth: '85%',
                padding: 16,
                borderRadius: 20,
                backgroundColor: C.green,
              }}
            >
              <Text style={[S.body, { color: C.white }]}>{pending}</Text>
            </View>
            <Text style={[S.body, { color: C.green }]}>✦ Đang nghĩ một ý tưởng hay cho bạn…</Text>
          </View>
        )}
        <ErrorBox message={history.error} retry={history.reload} />
        <ErrorBox message={error} />
      </ScrollView>
      {!!tripId && (
        <View
          style={{ padding: 16, paddingTop: 10, borderTopWidth: 1, borderColor: C.line, gap: 8 }}
        >
          <View
            style={[
              S.row,
              {
                padding: 7,
                paddingLeft: 16,
                borderWidth: 1,
                borderColor: C.line,
                borderRadius: 24,
                backgroundColor: C.white,
              },
            ]}
          >
            <TextInput
              accessibilityLabel="Tin nhắn cho AI"
              value={draft}
              onChangeText={setDraft}
              editable={!busy}
              multiline
              placeholder="Mình muốn khám phá…"
              placeholderTextColor={C.muted}
              style={{
                flex: 1,
                fontFamily: 'DM',
                fontSize: 14,
                color: C.ink,
                maxHeight: 100,
                paddingVertical: 10,
              }}
            />
            <Pressable
              accessibilityRole="button"
              accessibilityLabel="Gửi tin nhắn"
              disabled={busy || !draft.trim() || history.loading}
              onPress={() => send()}
              style={{
                padding: 12,
                borderRadius: 22,
                backgroundColor: C.green,
                opacity: busy || !draft.trim() ? 0.5 : 1,
              }}
            >
              <Icon name="arrow-up" color={C.white} size={20} />
            </Pressable>
          </View>
          <Text style={{ fontFamily: 'DM', fontSize: 9, color: C.muted, textAlign: 'center' }}>
            {session?.demo
              ? 'Chế độ trải nghiệm · phản hồi minh họa'
              : 'AI có thể nhầm lẫn. Kiểm tra lại giờ mở cửa và giá trước khi đi.'}
          </Text>
        </View>
      )}
    </KeyboardAvoidingView>
  );
}
