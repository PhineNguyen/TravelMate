import React, { useState } from 'react';
import { Pressable, RefreshControl, ScrollView, Text, View } from 'react-native';
import { useApp, useResource } from '../store';
import {
  Button,
  C,
  Cover,
  Empty,
  ErrorBox,
  Icon,
  IconButton,
  Loading,
  Pill,
  S,
  Section,
  Field,
} from '../ui';
import { destinations, photoFor } from '../demo';
import { compactMoney, dateLabel, tripFilter } from '../lib';
import type { Template, Trip } from '../types';
import type { Navigate } from '../navigation';

export function ExploreScreen({
  navigate,
  goTrips,
  goAI,
  goProfile,
}: {
  navigate: Navigate;
  goTrips: () => void;
  goAI: () => void;
  goProfile: () => void;
}) {
  const { session, request } = useApp();
  const [filter, setFilter] = useState('Tất cả');
  const [query, setQuery] = useState('');
  const trips = useResource(() => request<Trip[]>('/trips'), [request]);
  const patterns = useResource(() => request<Template[]>('/trip-templates'), [request]);
  const firstName = session?.user.fullName.split(' ').pop();
  const visible = destinations.filter(
    (d) =>
      (!query || d.name.toLocaleLowerCase('vi').includes(query.toLocaleLowerCase('vi'))) &&
      (filter === 'Tất cả' || d.tag === filter),
  );
  return (
    <ScrollView
      refreshControl={
        <RefreshControl
          refreshing={trips.loading && !!trips.data}
          onRefresh={() => {
            void trips.reload();
            void patterns.reload();
          }}
          tintColor={C.green}
        />
      }
      contentContainerStyle={S.page}
    >
      <View style={S.between}>
        <View style={{ gap: 5 }}>
          <Text style={S.label}>MỘT NGÀY ĐẸP ĐỂ ĐI</Text>
          <Text style={{ fontFamily: 'DMBold', color: C.ink, fontSize: 16 }}>
            Xin chào, {firstName} <Text style={{ fontSize: 16 }}>☀</Text>
          </Text>
        </View>
        <Pressable
          accessibilityRole="button"
          accessibilityLabel="Mở hồ sơ"
          onPress={goProfile}
          style={{
            backgroundColor: C.sand,
            width: 45,
            height: 45,
            borderRadius: 23,
            alignItems: 'center',
            justifyContent: 'center',
            borderWidth: 3,
            borderColor: C.white,
          }}
        >
          <Text style={{ fontFamily: 'Playfair', fontSize: 22, color: C.ink }}>
            {firstName?.[0] || 'T'}
          </Text>
        </Pressable>
      </View>
      <View style={{ gap: 8 }}>
        <Text style={S.title}>
          Chuyến đi tiếp theo,{'\n'}
          <Text style={{ color: C.green }}>bạn muốn đến đâu?</Text>
        </Text>
        <Text style={S.body}>Để những điều bình thường ở lại phía sau.</Text>
      </View>
      <View
        style={[
          S.row,
          {
            backgroundColor: C.white,
            borderRadius: 17,
            paddingLeft: 16,
            borderWidth: 1,
            borderColor: C.line,
          },
        ]}
      >
        <Icon name="search-outline" size={20} color={C.muted} />
        <View style={{ flex: 1 }}>
          <Field
            label=""
            accessibilityLabel="Tìm điểm đến"
            value={query}
            onChangeText={setQuery}
            placeholder="Một thành phố, một vùng đất mới…"
            style={{ borderWidth: 0, paddingLeft: 0, paddingVertical: 12, minHeight: 40 }}
          />
        </View>
        <View style={{ backgroundColor: C.soft, borderRadius: 12, padding: 10, marginRight: 7 }}>
          <Icon name="options-outline" size={18} />
        </View>
      </View>
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={{ gap: 8 }}
        style={{ marginTop: -8, marginRight: -24 }}
      >
        {(['Tất cả', 'Biển & nắng', 'Thiên nhiên', 'Văn hóa'] as const).map((f, i) => (
          <Pill
            key={f}
            selected={filter === f}
            onPress={() => setFilter(f)}
            icon={
              ['compass-outline', 'sunny-outline', 'leaf-outline', 'business-outline'][i] as any
            }
          >
            {f}
          </Pill>
        ))}
      </ScrollView>
      {visible.length ? (
        <Pressable
          accessibilityRole="button"
          accessibilityLabel={`Lên kế hoạch đến ${visible[0].name}`}
          onPress={() => navigate({ name: 'create', destination: visible[0].name })}
        >
          <Cover uri={visible[0].image} height={292}>
            <View
              style={{
                position: 'absolute',
                top: 18,
                left: 18,
                backgroundColor: '#FFFFFFE6',
                paddingHorizontal: 12,
                paddingVertical: 7,
                borderRadius: 20,
              }}
            >
              <Text style={{ fontFamily: 'DMBold', color: C.ink, fontSize: 10, letterSpacing: 1 }}>
                ĐIỂM ĐẾN TRONG MƠ
              </Text>
            </View>
            <View style={{ position: 'absolute', bottom: 22, left: 23, right: 23, gap: 8 }}>
              <Text style={{ fontFamily: 'DM', fontSize: 10, letterSpacing: 3, color: '#E5ECD8' }}>
                VIỆT NAM / {visible[0].region}
              </Text>
              <View style={S.between}>
                <View>
                  <Text style={{ fontFamily: 'Playfair', fontSize: 40, color: C.white }}>
                    {visible[0].name}
                  </Text>
                  <Text style={{ fontFamily: 'DM', color: '#E4EAE3', fontSize: 12, marginTop: 5 }}>
                    {visible[0].subtitle}
                  </Text>
                </View>
                <View style={{ backgroundColor: C.lime, borderRadius: 25, padding: 13 }}>
                  <Icon name="arrow-up-outline" size={22} />
                </View>
              </View>
            </View>
          </Cover>
        </Pressable>
      ) : (
        <Empty
          title="Chưa tìm thấy điểm đến"
          text="Thử tên khác hoặc tạo một chuyến đi của riêng bạn."
          action="Tạo chuyến đi"
          onPress={() => navigate({ name: 'create', destination: query })}
        />
      )}
      <Pressable
        accessibilityRole="button"
        onPress={goAI}
        style={[S.row, { backgroundColor: C.soft, borderRadius: 21, padding: 18, gap: 14 }]}
      >
        <View style={{ backgroundColor: C.lime, padding: 13, borderRadius: 16 }}>
          <Icon name="sparkles" size={22} color={C.green} />
        </View>
        <View style={{ flex: 1, gap: 4 }}>
          <Text style={{ fontFamily: 'DMBold', fontSize: 15, color: C.ink }}>
            Bạn mơ, AI lên kế hoạch.
          </Text>
          <Text style={[S.body, { fontSize: 12, lineHeight: 18 }]}>
            Một lịch trình vừa vặn với riêng bạn.
          </Text>
        </View>
        <Icon name="arrow-forward" size={20} />
      </Pressable>
      <View style={{ gap: 14 }}>
        <Section title="Hành trình của bạn" action="Xem tất cả" onPress={goTrips} />
        <ErrorBox message={trips.error} retry={trips.reload} />
        {trips.loading ? (
          <Loading />
        ) : trips.data?.length ? (
          <TripRow
            trip={trips.data[0]}
            onPress={() => navigate({ name: 'trip', trip: trips.data![0] })}
          />
        ) : !trips.error ? (
          <View style={[S.card, { gap: 12 }]}>
            <Text style={S.body}>
              Chưa có chuyến đi nào. Bắt đầu với một nơi bạn luôn muốn đến.
            </Text>
            <Button small secondary icon="add" onPress={() => navigate({ name: 'create' })}>
              Lên kế hoạch đầu tiên
            </Button>
          </View>
        ) : null}
      </View>
      <View style={{ gap: 14 }}>
        <Section title="Một chút cảm hứng" />
        <ErrorBox message={patterns.error} retry={patterns.reload} />
        {patterns.loading ? (
          <Loading />
        ) : (
          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={{ gap: 14 }}
            style={{ marginRight: -24 }}
          >
            {patterns.data?.map((t) => (
              <Pressable
                key={t.id}
                onPress={() =>
                  navigate({
                    name: 'create',
                    destination: t.destination,
                    templateId: t.id,
                    duration: t.duration,
                    budget: t.estimatedBudget,
                  })
                }
                style={{ width: 230 }}
              >
                <Cover
                  uri={t.thumbnailUrl || photoFor(t.destination)}
                  height={145}
                  style={{ borderRadius: 18 }}
                />
                <View style={{ gap: 5, paddingTop: 12 }}>
                  <Text
                    style={{ fontFamily: 'DMBold', color: C.ink, fontSize: 14 }}
                    numberOfLines={1}
                  >
                    {t.title}
                  </Text>
                  <Text style={[S.body, { fontSize: 12 }]}>
                    {t.duration} ngày · từ {compactMoney(t.estimatedBudget)} / chuyến
                  </Text>
                </View>
              </Pressable>
            ))}
          </ScrollView>
        )}
        {!patterns.loading && !patterns.error && !patterns.data?.length && (
          <Text style={S.body}>Những hành trình mẫu sẽ sớm xuất hiện ở đây.</Text>
        )}
      </View>
      <Text style={[S.label, { textAlign: 'center', fontSize: 9, paddingTop: 9 }]}>
        LESS PLANNING. MORE LIVING.
      </Text>
    </ScrollView>
  );
}
export function TripRow({ trip, onPress }: { trip: Trip; onPress: () => void }) {
  return (
    <Pressable
      accessibilityRole="button"
      onPress={onPress}
      style={[S.card, S.row, { padding: 12 }]}
    >
      <Cover uri={photoFor(trip.destination)} height={78} style={{ width: 78, borderRadius: 15 }} />
      <View style={{ flex: 1, gap: 7 }}>
        <Text style={{ fontFamily: 'DMBold', color: C.ink, fontSize: 17 }}>{trip.destination}</Text>
        <Text style={[S.body, { fontSize: 12, lineHeight: 17 }]}>
          {dateLabel(trip.startDate)} — {dateLabel(trip.endDate)}
        </Text>
        <Text style={{ fontFamily: 'DM', fontSize: 11, color: C.green }}>
          {trip.duration} ngày · {trip.travelerCount} người
        </Text>
      </View>
      <Icon name="chevron-forward" size={18} />
    </Pressable>
  );
}

export function TripsScreen({ navigate }: { navigate: Navigate }) {
  const { request } = useApp();
  const trips = useResource(() => request<Trip[]>('/trips'), [request]);
  const [filter, setFilter] = useState('Tất cả');
  const shown = trips.data?.filter((t) => tripFilter(t.tripStatus, filter));
  return (
    <ScrollView
      refreshControl={
        <RefreshControl refreshing={trips.loading && !!trips.data} onRefresh={trips.reload} />
      }
      contentContainerStyle={S.page}
    >
      <View style={S.between}>
        <View style={{ gap: 8 }}>
          <Text style={S.label}>NHỮNG CÂU CHUYỆN CỦA BẠN</Text>
          <Text style={S.title}>Hành trình.</Text>
        </View>
        <IconButton name="add" label="Tạo chuyến đi" onPress={() => navigate({ name: 'create' })} />
      </View>
      <View style={S.row}>
        {['Tất cả', 'Sắp tới', 'Đã đi'].map((f) => (
          <Pill key={f} selected={filter === f} onPress={() => setFilter(f)}>
            {f}
          </Pill>
        ))}
      </View>
      <ErrorBox message={trips.error} retry={trips.reload} />
      {trips.loading ? (
        <Loading />
      ) : shown?.length ? (
        shown.map((t) => (
          <Pressable key={t.id} onPress={() => navigate({ name: 'trip', trip: t })}>
            <Cover uri={photoFor(t.destination)} height={245}>
              <View
                style={{
                  position: 'absolute',
                  top: 18,
                  left: 18,
                  paddingHorizontal: 12,
                  paddingVertical: 7,
                  borderRadius: 20,
                  backgroundColor: C.lime,
                }}
              >
                <Text style={{ fontFamily: 'DMBold', color: C.green, fontSize: 10 }}>
                  {t.planningMode === 'AI'
                    ? '✦ LÊN KẾ HOẠCH BẰNG AI'
                    : t.tripStatus === 'COMPLETED'
                      ? 'MỘT KỶ NIỆM ĐẸP'
                      : 'HÀNH TRÌNH CỦA BẠN'}
                </Text>
              </View>
              <View style={{ position: 'absolute', bottom: 22, left: 22, right: 22, gap: 10 }}>
                <Text style={{ fontFamily: 'Playfair', color: C.white, fontSize: 34 }}>
                  {t.destination}
                </Text>
                <Text style={{ fontFamily: 'DM', color: '#E3E9E1', fontSize: 12 }}>
                  {dateLabel(t.startDate)} — {dateLabel(t.endDate)} · {t.duration} ngày
                </Text>
              </View>
            </Cover>
          </Pressable>
        ))
      ) : (
        !trips.error && (
          <Empty
            title="Một trang mới đang chờ"
            text="Chọn một điểm đến. Những phần còn lại, mình cùng lên kế hoạch."
            action="Tạo chuyến đi"
            onPress={() => navigate({ name: 'create' })}
          />
        )
      )}
    </ScrollView>
  );
}
