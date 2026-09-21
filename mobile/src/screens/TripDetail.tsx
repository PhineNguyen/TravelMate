import React, { useState } from 'react';
import {
  KeyboardAvoidingView,
  Linking,
  Modal,
  Platform,
  Pressable,
  ScrollView,
  Text,
  View,
} from 'react-native';
import { useApp, useResource } from '../store';
import {
  Button,
  C,
  Cover,
  Empty,
  ErrorBox,
  Field,
  Header,
  Icon,
  IconButton,
  Loading,
  Pill,
  S,
  Section,
} from '../ui';
import { photoFor } from '../demo';
import { compactMoney, dateLabel, errorText, money, positiveNumber, today } from '../lib';
import type { Budget, Category, Expense, Item, Place, Trip, Weather } from '../types';

export const categories: { id: Category; name: string; icon: any; color: string }[] = [
  { id: 'FOOD', name: 'Ăn uống', icon: 'restaurant-outline', color: '#F5E8D7' },
  { id: 'HOTEL', name: 'Lưu trú', icon: 'bed-outline', color: '#E5EBDD' },
  { id: 'TRANSPORT', name: 'Di chuyển', icon: 'car-outline', color: '#E3EBEF' },
  { id: 'ENTERTAINMENT', name: 'Trải nghiệm', icon: 'ticket-outline', color: '#EDE5F1' },
  { id: 'SHOPPING', name: 'Mua sắm', icon: 'bag-outline', color: '#F5E3DF' },
  { id: 'OTHER', name: 'Khác', icon: 'ellipsis-horizontal', color: '#EBEBE7' },
];
export function Sheet({
  title,
  close,
  children,
}: {
  title: string;
  close: () => void;
  children: React.ReactNode;
}) {
  return (
    <Modal visible transparent animationType="slide" onRequestClose={close}>
      <View
        style={{
          flex: 1,
          backgroundColor: '#11271C80',
          justifyContent: 'flex-end',
          alignItems: 'center',
        }}
      >
        <KeyboardAvoidingView
          behavior={Platform.OS === 'ios' ? 'padding' : undefined}
          style={{
            width: '100%',
            maxWidth: 480,
            maxHeight: '90%',
            backgroundColor: C.bg,
            borderTopLeftRadius: 28,
            borderTopRightRadius: 28,
          }}
        >
          <View
            style={{
              alignSelf: 'center',
              width: 36,
              height: 4,
              backgroundColor: '#CBD0C8',
              borderRadius: 4,
              marginTop: 12,
            }}
          />
          <View style={[S.between, { padding: 20, paddingBottom: 6 }]}>
            <Text style={S.heading}>{title}</Text>
            <IconButton name="close" label="Đóng" onPress={close} />
          </View>
          <ScrollView
            keyboardShouldPersistTaps="handled"
            contentContainerStyle={[S.page, { paddingTop: 14, paddingBottom: 38 }]}
          >
            {children}
          </ScrollView>
        </KeyboardAvoidingView>
      </View>
    </Modal>
  );
}

export function TripDetailScreen({
  initialTrip,
  back,
  chat,
}: {
  initialTrip: Trip;
  back: () => void;
  chat: (trip: Trip) => void;
}) {
  const { request, session } = useApp();
  const [trip, setTrip] = useState(initialTrip);
  const [tab, setTab] = useState('Lịch trình');
  const [day, setDay] = useState(1);
  const items = useResource(
    () => request<Item[]>(`/itinerary-items/trip/${trip.id}`),
    [request, trip.id],
  );
  const budget = useResource(
    () => request<Budget>(`/insights/trips/${trip.id}/budget`),
    [request, trip.id],
  );
  const expenses = useResource(async () => {
    let page = 0;
    const rows: Expense[] = [];
    while (true) {
      const batch = await request<{ content: Expense[]; last: boolean }>(
        `/expenses/trip/${trip.id}?size=100&page=${page++}`,
      );
      rows.push(...batch.content);
      if (batch.last || !batch.content.length) return rows;
    }
  }, [request, trip.id]);
  const weather = useResource(
    () => request<Weather>(`/weather/trip/${trip.id}`),
    [request, trip.id],
  );
  const [sheet, setSheet] = useState<'add' | 'expense' | 'options' | 'item' | null>(null);
  const [selected, setSelected] = useState<Item>();
  const [edited, setEdited] = useState<Expense>();
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);
  const [deleted, setDeleted] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);
  const [tripBudget, setTripBudget] = useState(String(trip.totalBudget));
  const [tripName, setTripName] = useState(trip.destination);
  const [search, setSearch] = useState('');
  const [results, setResults] = useState<Place[]>([]);
  const [searched, setSearched] = useState(false);
  const [place, setPlace] = useState<Place>();
  const [time, setTime] = useState('09:00');
  const [note, setNote] = useState('');
  const [customName, setCustomName] = useState('');
  const [amount, setAmount] = useState('');
  const [description, setDescription] = useState('');
  const [category, setCategory] = useState<Category>('FOOD');
  const open = (s: typeof sheet) => {
    setError('');
    setConfirmDelete(false);
    setSheet(s);
  };
  const perform = async (action: () => Promise<void>) => {
    setError('');
    setBusy(true);
    try {
      await action();
    } catch (e) {
      setError(errorText(e));
    } finally {
      setBusy(false);
    }
  };
  const refresh = async () => {
    await Promise.all([items.reload(), expenses.reload(), budget.reload()]);
  };
  const daily = items.data?.filter((i) => i.dayNumber === day) || [];
  const nextStatus = (
    {
      DRAFT: ['PLANNED', 'Sẵn sàng khởi hành'],
      PLANNED: ['ACTIVE', 'Bắt đầu chuyến đi'],
      ACTIVE: ['COMPLETED', 'Hoàn thành chuyến đi'],
    } as Record<string, [string, string]>
  )[trip.tripStatus];
  const reorder = (item: Item, direction: number) =>
    perform(async () => {
      const index = daily.findIndex((i) => i.id === item.id);
      const next = index + direction;
      if (next < 0 || next >= daily.length) return;
      const list = [...daily];
      [list[index], list[next]] = [list[next], list[index]];
      await request(
        '/itinerary-items/reorder',
        'PUT',
        list.map((i, k) => ({ id: i.id, dayNumber: day, orderIndex: k + 1 })),
      );
      await items.reload();
    });
  const saveExpense = () =>
    perform(async () => {
      const value = positiveNumber(amount, 'Số tiền');
      if (!description.trim()) throw new Error('Thêm mô tả khoản chi nhé.');
      await request(edited ? `/expenses/${edited.id}` : '/expenses', edited ? 'PUT' : 'POST', {
        tripId: trip.id,
        createdById: session!.user.id,
        amount: value,
        category,
        description: description.trim(),
        expenseDate: edited?.expenseDate || today(),
      });
      await Promise.all([expenses.reload(), budget.reload()]);
      setSheet(null);
    });
  const addItem = () =>
    perform(async () => {
      if (!/^([01]\d|2[0-3]):[0-5]\d$/.test(time))
        throw new Error('Giờ cần theo dạng HH:mm, ví dụ 09:00.');
      let chosen = place;
      if (!chosen && customName.trim())
        chosen = await request<Place>('/places', 'POST', {
          name: customName.trim(),
          city: trip.destination,
          country: 'Vietnam',
          description: note,
        });
      if (!chosen) throw new Error('Chọn địa điểm hoặc nhập tên một địa điểm mới.');
      await request('/itinerary-items', 'POST', {
        tripId: trip.id,
        placeId: chosen.id,
        dayNumber: day,
        orderIndex: Math.max(0, ...daily.map((i) => i.orderIndex)) + 1,
        startTime: time + ':00',
        note,
        sourceType: 'MANUAL',
      });
      await items.reload();
      void weather.reload();
      setSheet(null);
    });
  if (deleted)
    return (
      <View style={{ flex: 1 }}>
        <Header title="Đã xóa chuyến đi" back={back} />
        <View style={S.page}>
          <Empty
            icon="archive-outline"
            title="Đã cất hành trình này đi"
            text="Bạn có thể khôi phục ngay nếu vừa xóa nhầm."
          />
          <ErrorBox message={error} />
          <Button
            busy={busy}
            onPress={() =>
              perform(async () => {
                const restored = await request<Trip>(`/trips/${trip.id}/restore`, 'PUT');
                setTrip(restored);
                setDeleted(false);
                setSheet(null);
              })
            }
          >
            Khôi phục chuyến đi
          </Button>
          <Button secondary onPress={back}>
            Về hành trình của bạn
          </Button>
        </View>
      </View>
    );
  return (
    <View style={{ flex: 1 }}>
      <ScrollView contentContainerStyle={{ paddingBottom: 30 }}>
        <Cover uri={photoFor(trip.destination)} height={272} style={{ borderRadius: 0 }}>
          <View style={[S.between, { padding: 20 }]}>
            <IconButton light name="arrow-back" label="Quay lại" onPress={back} />
            <IconButton
              light
              name="ellipsis-horizontal"
              label="Tùy chọn chuyến đi"
              onPress={() => open('options')}
            />
          </View>
          <View style={{ position: 'absolute', bottom: 25, left: 25, right: 25, gap: 9 }}>
            <Text style={{ fontFamily: 'DM', fontSize: 10, letterSpacing: 3, color: '#E4EDD5' }}>
              MỘT CHUYẾN ĐI, NHIỀU KỶ NIỆM
            </Text>
            <Text style={{ fontFamily: 'Playfair', fontSize: 42, color: C.white }}>
              {trip.destination}
            </Text>
            <Text style={{ fontFamily: 'DM', fontSize: 12, color: C.white }}>
              {dateLabel(trip.startDate)} — {dateLabel(trip.endDate)} · {trip.travelerCount} người
            </Text>
          </View>
        </Cover>
        <View style={[S.page, { gap: 20 }]}>
          <View style={[S.between, { backgroundColor: C.soft, padding: 14, borderRadius: 16 }]}>
            <View style={S.row}>
              <Icon name="partly-sunny-outline" color={C.green} />
              <View>
                <Text style={{ fontFamily: 'DMBold', fontSize: 13, color: C.ink }}>
                  {weather.data &&
                  !weather.data.condition.toLowerCase().includes('unavailable') &&
                  weather.data.city !== 'Unknown'
                    ? `${Math.round(weather.data.temperature)}° · ${weather.data.condition}`
                    : 'Thời tiết chưa có dữ liệu'}
                </Text>
                <Text style={{ fontFamily: 'DM', fontSize: 11, color: C.muted, marginTop: 4 }}>
                  {weather.data && !weather.data.isOutdoorSafe
                    ? 'Cân nhắc hoạt động trong nhà nhé.'
                    : 'Một ngày đẹp bắt đầu bằng một kế hoạch hay.'}
                </Text>
              </View>
            </View>
          </View>
          <View
            style={{
              flexDirection: 'row',
              backgroundColor: '#EDEFE7',
              padding: 4,
              borderRadius: 16,
            }}
          >
            {['Lịch trình', 'Chi tiêu'].map((t) => (
              <Pressable
                accessibilityRole="tab"
                accessibilityState={{ selected: tab === t }}
                key={t}
                onPress={() => setTab(t)}
                style={{
                  flex: 1,
                  padding: 12,
                  borderRadius: 12,
                  backgroundColor: tab === t ? C.white : 'transparent',
                  alignItems: 'center',
                }}
              >
                <Text
                  style={{
                    fontFamily: 'DMBold',
                    fontSize: 13,
                    color: tab === t ? C.green : C.muted,
                  }}
                >
                  {t}
                </Text>
              </Pressable>
            ))}
          </View>
          {tab === 'Lịch trình' ? (
            <>
              <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={{ gap: 9 }}
              >
                {Array.from({ length: trip.duration }, (_, i) => (
                  <Pill
                    key={i}
                    selected={day === i + 1}
                    onPress={() => setDay(i + 1)}
                  >{`Ngày ${i + 1}`}</Pill>
                ))}
              </ScrollView>
              <Section
                title={`Một ngày ở ${trip.destination}`}
                action="Thêm điểm"
                onPress={() => {
                  setPlace(undefined);
                  setResults([]);
                  setSearched(false);
                  setSearch('');
                  setCustomName('');
                  setNote('');
                  open('add');
                }}
              />
              <ErrorBox message={items.error || (!sheet ? error : '')} retry={items.reload} />
              {items.loading ? (
                <Loading />
              ) : daily.length ? (
                daily.map((item, index) => (
                  <View key={item.id} style={{ flexDirection: 'row', gap: 12 }}>
                    <View style={{ width: 43, alignItems: 'center' }}>
                      <Text
                        style={{
                          fontFamily: 'DMBold',
                          color: C.green,
                          fontSize: 11,
                          paddingTop: 16,
                        }}
                      >
                        {item.startTime?.slice(0, 5) || '—'}
                      </Text>
                      <View style={{ width: 1, flex: 1, backgroundColor: C.line, marginTop: 10 }} />
                    </View>
                    <View style={[S.card, { flex: 1, padding: 16, gap: 12 }]}>
                      <Pressable
                        onPress={() => {
                          setSelected(item);
                          setTime(item.startTime?.slice(0, 5) || '09:00');
                          setNote(item.note || '');
                          open('item');
                        }}
                      >
                        <Text style={{ fontFamily: 'DMBold', fontSize: 16, color: C.ink }}>
                          {item.place?.name || 'Hoạt động tự chọn'}
                        </Text>
                        <Text numberOfLines={2} style={[S.body, { fontSize: 12, marginTop: 7 }]}>
                          {item.note ||
                            item.place?.description ||
                            'Một điểm dừng trên hành trình của bạn.'}
                        </Text>
                      </Pressable>
                      <View style={S.between}>
                        <Text style={{ fontFamily: 'DM', fontSize: 11, color: C.muted }}>
                          {item.duration ? `${item.duration} phút` : 'Tự do khám phá'}{' '}
                          {item.costEstimate ? `· ${compactMoney(item.costEstimate)}` : ''}
                        </Text>
                        <View style={{ flexDirection: 'row', gap: 6 }}>
                          <Pressable
                            accessibilityLabel="Chuyển điểm lên"
                            disabled={busy || index === 0}
                            onPress={() => reorder(item, -1)}
                            style={{ padding: 7, opacity: index === 0 ? 0.25 : 1 }}
                          >
                            <Icon name="arrow-up" size={15} />
                          </Pressable>
                          <Pressable
                            accessibilityLabel="Chuyển điểm xuống"
                            disabled={busy || index === daily.length - 1}
                            onPress={() => reorder(item, 1)}
                            style={{ padding: 7, opacity: index === daily.length - 1 ? 0.25 : 1 }}
                          >
                            <Icon name="arrow-down" size={15} />
                          </Pressable>
                        </View>
                      </View>
                    </View>
                  </View>
                ))
              ) : (
                !items.error && (
                  <Empty
                    title="Ngày này vẫn còn tự do"
                    text="Thêm một nơi muốn đến, một quán muốn thử hay một khoảng nghỉ."
                    action="Thêm điểm đến"
                    onPress={() => {
                      setPlace(undefined);
                      open('add');
                    }}
                  />
                )
              )}
              <Button secondary icon="sparkles" onPress={() => chat(trip)}>
                Hỏi AI về chuyến đi này
              </Button>
            </>
          ) : (
            <>
              <View style={{ backgroundColor: C.green, padding: 23, borderRadius: 24, gap: 15 }}>
                <Text
                  style={{ fontFamily: 'DM', fontSize: 11, letterSpacing: 1, color: '#D7E4D1' }}
                >
                  NGÂN SÁCH CỦA BẠN
                </Text>
                <Text style={{ fontFamily: 'DMBold', fontSize: 31, color: C.white }}>
                  {money(budget.data?.spentBudget || 0)}
                </Text>
                <Text style={{ fontFamily: 'DM', fontSize: 12, color: '#C7D8C4' }}>
                  đã chi / {money(budget.data?.plannedBudget || trip.totalBudget)}
                </Text>
                <View style={{ height: 6, borderRadius: 3, backgroundColor: '#FFFFFF30' }}>
                  <View
                    style={{
                      height: 6,
                      borderRadius: 3,
                      width: `${Math.min(100, budget.data?.utilizationPercent || 0)}%`,
                      backgroundColor: C.lime,
                    }}
                  />
                </View>
                <Text style={{ fontFamily: 'DM', fontSize: 12, color: C.lime }}>
                  {(budget.data?.remainingBudget || 0) < 0 ? 'Vượt ngân sách ' : 'Còn lại '}
                  {money(Math.abs(budget.data?.remainingBudget || 0))}
                </Text>
              </View>
              <ErrorBox message={budget.error} retry={budget.reload} />
              <Section
                title="Những khoản đã chi"
                action="Thêm khoản"
                onPress={() => {
                  setEdited(undefined);
                  setAmount('');
                  setDescription('');
                  setCategory('FOOD');
                  open('expense');
                }}
              />
              <ErrorBox message={expenses.error} retry={expenses.reload} />
              {expenses.loading ? (
                <Loading />
              ) : expenses.data?.length ? (
                expenses.data.map((e) => {
                  const cat = categories.find((c) => c.id === e.category)!;
                  return (
                    <Pressable
                      key={e.id}
                      onPress={() => {
                        setEdited(e);
                        setAmount(String(e.amount));
                        setDescription(e.description);
                        setCategory(e.category);
                        open('expense');
                      }}
                      style={[S.row, { paddingVertical: 6 }]}
                    >
                      <View style={{ padding: 14, backgroundColor: cat.color, borderRadius: 16 }}>
                        <Icon name={cat.icon} size={21} />
                      </View>
                      <View style={{ flex: 1, gap: 5 }}>
                        <Text
                          numberOfLines={1}
                          style={{ fontFamily: 'DMBold', fontSize: 13, color: C.ink }}
                        >
                          {e.description || cat.name}
                        </Text>
                        <Text style={{ fontFamily: 'DM', fontSize: 11, color: C.muted }}>
                          {cat.name} · {dateLabel(e.expenseDate)}
                        </Text>
                      </View>
                      <Text style={{ fontFamily: 'DMBold', fontSize: 13, color: C.ink }}>
                        {money(e.amount)}
                      </Text>
                    </Pressable>
                  );
                })
              ) : (
                <Empty
                  title="Chưa có khoản chi nào"
                  text="Ghi lại chi tiêu để tận hưởng chuyến đi nhẹ đầu hơn."
                />
              )}
            </>
          )}
        </View>
      </ScrollView>
      {sheet && (
        <Sheet
          title={
            sheet === 'add'
              ? 'Một điểm dừng mới'
              : sheet === 'expense'
                ? edited
                  ? 'Sửa khoản chi'
                  : 'Ghi lại một khoản chi'
                : sheet === 'item'
                  ? 'Điểm dừng của bạn'
                  : 'Tùy chọn hành trình'
          }
          close={() => {
            if (!busy) setSheet(null);
          }}
        >
          {sheet === 'add' && (
            <>
              <Field
                label="Tìm địa điểm có sẵn"
                value={search}
                onChangeText={setSearch}
                placeholder="Tên bãi biển, quán cà phê…"
              />
              <Button
                secondary
                small
                busy={busy}
                onPress={() =>
                  perform(async () => {
                    setResults(
                      await request<Place[]>(`/places?query=${encodeURIComponent(search.trim())}`),
                    );
                    setSearched(true);
                  })
                }
              >
                Tìm địa điểm
              </Button>
              {results.map((p) => (
                <Pill
                  key={p.id}
                  selected={place?.id === p.id}
                  onPress={() => {
                    setPlace(p);
                    setCustomName('');
                  }}
                >
                  {p.name}
                </Pill>
              ))}
              {searched && !results.length && (
                <Text style={S.body}>Chưa thấy địa điểm này. Bạn có thể tự thêm bên dưới.</Text>
              )}
              <Field
                label="Hoặc tự tạo địa điểm mới"
                value={customName}
                onChangeText={(v) => {
                  setCustomName(v);
                  setPlace(undefined);
                }}
                placeholder="Tên điểm đến của bạn"
              />
              <Field label="Giờ bắt đầu (HH:mm)" value={time} onChangeText={setTime} />
              <Field
                label="Ghi chú"
                value={note}
                onChangeText={setNote}
                multiline
                placeholder="Điều bạn muốn nhớ…"
              />
              <Button busy={busy} onPress={addItem}>{`Thêm vào ngày ${day}`}</Button>
            </>
          )}
          {sheet === 'expense' && (
            <>
              <Field
                label="Số tiền (VNĐ)"
                value={amount}
                onChangeText={setAmount}
                keyboardType="number-pad"
                placeholder="150000"
              />
              <Field
                label="Mô tả"
                value={description}
                onChangeText={setDescription}
                placeholder="Bữa tối bên bờ biển"
              />
              <View style={[S.row, { flexWrap: 'wrap', gap: 8 }]}>
                {categories.map((c) => (
                  <Pill key={c.id} selected={category === c.id} onPress={() => setCategory(c.id)}>
                    {c.name}
                  </Pill>
                ))}
              </View>
              <Button busy={busy} onPress={saveExpense}>
                Lưu khoản chi
              </Button>
              {edited && (
                <Button
                  secondary
                  busy={busy}
                  onPress={() =>
                    perform(async () => {
                      await request(`/expenses/${edited.id}`, 'DELETE');
                      await refresh();
                      setSheet(null);
                    })
                  }
                >
                  Xóa khoản chi này
                </Button>
              )}
            </>
          )}
          {sheet === 'item' && selected && (
            <>
              <Text style={S.title}>{selected.place?.name || 'Hoạt động'}</Text>
              <Text style={S.body}>
                {selected.note || selected.place?.description || 'Một điểm dừng của riêng bạn.'}
              </Text>
              {!!selected.place?.rating && (
                <Text style={S.body}>★ {selected.place.rating} / 5</Text>
              )}
              <Field label="Giờ bắt đầu (HH:mm)" value={time} onChangeText={setTime} />
              <Field label="Ghi chú cho điểm đến" value={note} onChangeText={setNote} multiline />
              <Button
                busy={busy}
                onPress={() =>
                  perform(async () => {
                    if (!/^([01]\d|2[0-3]):[0-5]\d$/.test(time))
                      throw new Error('Giờ cần theo dạng HH:mm.');
                    await request(`/itinerary-items/${selected.id}`, 'PUT', {
                      startTime: `${time}:00`,
                      note: note.trim(),
                    });
                    await items.reload();
                    setSheet(null);
                  })
                }
              >
                Lưu điểm đến
              </Button>
              <Button
                icon="navigate-outline"
                onPress={() =>
                  perform(async () => {
                    const p = selected.place;
                    const target =
                      p?.latitude != null && p?.longitude != null
                        ? `${p.latitude},${p.longitude}`
                        : `${p?.name || ''} ${trip.destination}`;
                    await Linking.openURL(
                      `https://www.google.com/maps/dir/?api=1&destination=${encodeURIComponent(target)}`,
                    );
                  })
                }
              >
                Chỉ đường bằng Google Maps
              </Button>
              <Button
                secondary
                busy={busy}
                onPress={() =>
                  perform(async () => {
                    await request(`/itinerary-items/${selected.id}`, 'DELETE');
                    await items.reload();
                    setSheet(null);
                  })
                }
              >
                Bỏ khỏi lịch trình
              </Button>
            </>
          )}
          {sheet === 'options' && (
            <>
              <Field label="Tên điểm đến" value={tripName} onChangeText={setTripName} />
              <Field
                label="Ngân sách chuyến đi (VNĐ)"
                value={tripBudget}
                onChangeText={setTripBudget}
                keyboardType="number-pad"
              />
              <Button
                busy={busy}
                onPress={() =>
                  perform(async () => {
                    if (!tripName.trim()) throw new Error('Tên điểm đến không được để trống.');
                    const updated = await request<Trip>(`/trips/${trip.id}`, 'PUT', {
                      destination: tripName.trim(),
                      totalBudget: positiveNumber(tripBudget, 'Ngân sách', true),
                    });
                    setTrip(updated);
                    await budget.reload();
                    setSheet(null);
                  })
                }
              >
                Lưu thông tin chuyến đi
              </Button>
              {nextStatus && (
                <Button
                  secondary
                  busy={busy}
                  onPress={() =>
                    perform(async () => {
                      setTrip(
                        await request<Trip>(`/trips/${trip.id}`, 'PUT', {
                          tripStatus: nextStatus[0],
                        }),
                      );
                      setSheet(null);
                    })
                  }
                >
                  {nextStatus[1]}
                </Button>
              )}
              <Button secondary onPress={() => setConfirmDelete(true)}>
                Xóa chuyến đi
              </Button>
              {confirmDelete && (
                <View style={{ gap: 12 }}>
                  <Text style={[S.body, { color: C.red }]}>
                    Chuyến đi sẽ được ẩn khỏi danh sách. Bạn có thể khôi phục ngay sau khi xóa.
                  </Text>
                  <Button
                    busy={busy}
                    onPress={() =>
                      perform(async () => {
                        await request(`/trips/${trip.id}`, 'DELETE');
                        setDeleted(true);
                        setSheet(null);
                      })
                    }
                  >
                    Xác nhận xóa chuyến đi
                  </Button>
                </View>
              )}
            </>
          )}
          <ErrorBox message={error} />
        </Sheet>
      )}
    </View>
  );
}
