import React, { useState } from 'react';
import { Pressable, ScrollView, Text, View } from 'react-native';
import { useApp, useResource } from '../store';
import { Button, C, ErrorBox, Field, Header, Icon, Pill, S } from '../ui';
import { Sheet } from './TripDetail';
import { errorText, positiveNumber } from '../lib';
import type { Preference, User } from '../types';
export function ProfileScreen({ preferences }: { preferences: () => void }) {
  const app = useApp();
  const user = app.session!.user;
  const [panel, setPanel] = useState<'profile' | 'server' | 'delete' | null>(null);
  const [name, setName] = useState(user.fullName);
  const [location, setLocation] = useState(user.location || '');
  const [server, setServer] = useState(app.baseUrl);
  const [confirm, setConfirm] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const run = async (fn: () => Promise<void>) => {
    setBusy(true);
    setError('');
    try {
      await fn();
    } catch (e) {
      setError(errorText(e));
    } finally {
      setBusy(false);
    }
  };
  const open = (p: typeof panel) => {
    setError('');
    setPanel(p);
  };
  const rows = [
    {
      icon: 'person-outline',
      title: 'Thông tin cá nhân',
      sub: 'Để người bạn đồng hành hiểu bạn hơn',
      action: () => open('profile'),
    },
    {
      icon: 'heart-outline',
      title: 'Gu du lịch của bạn',
      sub: 'Sở thích, phong cách & ngân sách',
      action: preferences,
    },
    {
      icon: 'server-outline',
      title: 'Kết nối máy chủ',
      sub: 'Cấu hình backend TravelMate',
      action: () => open('server'),
    },
  ];
  return (
    <ScrollView contentContainerStyle={S.page}>
      <View style={{ gap: 8 }}>
        <Text style={S.label}>BẠN LÀ MỘT PHẦN CỦA HÀNH TRÌNH</Text>
        <Text style={S.title}>Góc của bạn.</Text>
      </View>
      <View style={{ alignItems: 'center', paddingVertical: 15, gap: 10 }}>
        <View
          style={{
            width: 92,
            height: 92,
            borderRadius: 46,
            backgroundColor: C.sand,
            alignItems: 'center',
            justifyContent: 'center',
            borderWidth: 5,
            borderColor: C.white,
          }}
        >
          <Text style={{ fontFamily: 'Playfair', fontSize: 40, color: C.green }}>
            {user.fullName.split(' ').pop()?.[0]}
          </Text>
        </View>
        <Text style={S.heading}>{user.fullName}</Text>
        <Text style={S.body}>{app.session?.demo ? 'Người bạn trải nghiệm' : user.email}</Text>
        <View
          style={{
            backgroundColor: C.soft,
            paddingHorizontal: 14,
            paddingVertical: 7,
            borderRadius: 20,
          }}
        >
          <Text style={{ fontFamily: 'DMBold', fontSize: 10, color: C.green, letterSpacing: 1 }}>
            COLLECT MOMENTS, NOT THINGS
          </Text>
        </View>
      </View>
      <View style={[S.card, { paddingVertical: 4 }]}>
        {rows.map((r, i) => (
          <Pressable
            key={r.title}
            onPress={r.action}
            style={[
              S.row,
              { paddingVertical: 21, borderBottomWidth: i < 2 ? 1 : 0, borderColor: C.line },
            ]}
          >
            <Icon name={r.icon as any} color={C.green} />
            <View style={{ flex: 1, gap: 5 }}>
              <Text style={{ fontFamily: 'DMBold', fontSize: 14, color: C.ink }}>{r.title}</Text>
              <Text style={{ fontFamily: 'DM', fontSize: 11, color: C.muted }}>{r.sub}</Text>
            </View>
            <Icon name="chevron-forward" size={16} />
          </Pressable>
        ))}
      </View>
      <ErrorBox message={!panel ? error : ''} />
      <Button secondary busy={busy} icon="log-out-outline" onPress={() => run(app.logout)}>
        {app.session?.demo ? 'Thoát bản trải nghiệm' : 'Đăng xuất'}
      </Button>
      {!app.session?.demo && (
        <Pressable onPress={() => open('delete')} style={{ padding: 12 }}>
          <Text style={{ fontFamily: 'DM', fontSize: 12, color: C.red, textAlign: 'center' }}>
            Xóa tài khoản của tôi
          </Text>
        </Pressable>
      )}
      <View style={{ alignItems: 'center', gap: 8, paddingTop: 20 }}>
        <Icon name="navigate" size={22} color={C.green} />
        <Text style={[S.label, { fontSize: 9 }]}>TRAVELMATE · MADE FOR YOUR NEXT CHAPTER</Text>
      </View>
      {panel && (
        <Sheet
          title={
            panel === 'profile'
              ? 'Thông tin cá nhân'
              : panel === 'server'
                ? 'Kết nối máy chủ'
                : 'Xóa tài khoản'
          }
          close={() => {
            if (!busy) setPanel(null);
          }}
        >
          {panel === 'profile' ? (
            <>
              <Field label="Họ tên" value={name} onChangeText={setName} />
              <Field label="Nơi bạn sống" value={location} onChangeText={setLocation} />
              <Button
                busy={busy}
                onPress={() =>
                  run(async () => {
                    if (!name.trim()) throw new Error('Tên không được để trống.');
                    const saved = await app.request<User>(`/users/${user.id}`, 'PUT', {
                      fullName: name.trim(),
                      location: location.trim(),
                    });
                    await app.setSession({ ...app.session!, user: saved });
                    setPanel(null);
                  })
                }
              >
                Lưu thay đổi
              </Button>
            </>
          ) : panel === 'server' ? (
            <>
              <Text style={S.body}>
                Đổi máy chủ sẽ đăng xuất phiên hiện tại. Trên điện thoại, dùng IP máy chạy backend
                trong cùng Wi-Fi.
              </Text>
              <Field
                label="Địa chỉ backend"
                value={server}
                onChangeText={setServer}
                autoCapitalize="none"
              />
              <Button
                busy={busy}
                onPress={() =>
                  run(async () => {
                    await app.setBaseUrl(server);
                  })
                }
              >
                Lưu kết nối và đăng xuất
              </Button>
            </>
          ) : (
            <>
              <Text style={[S.body, { color: C.red }]}>
                Tài khoản và dữ liệu chuyến đi sẽ bị xóa vĩnh viễn. Nhập email của bạn để xác nhận.
              </Text>
              <Field
                label="Email xác nhận"
                value={confirm}
                onChangeText={setConfirm}
                autoCapitalize="none"
              />
              <Button
                disabled={confirm !== user.email}
                busy={busy}
                onPress={() =>
                  run(async () => {
                    await app.request(`/users/${user.id}`, 'DELETE');
                    await app.setSession(null);
                  })
                }
              >
                Xóa vĩnh viễn tài khoản
              </Button>
            </>
          )}
          <ErrorBox message={error} />
        </Sheet>
      )}
    </ScrollView>
  );
}
export function PreferencesScreen({ back }: { back: () => void }) {
  const { request, session } = useApp();
  const [style, setStyle] = useState('Thư giãn');
  const [budget, setBudget] = useState('5000000');
  const [region, setRegion] = useState('Việt Nam');
  const [id, setId] = useState<number>();
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);
  const [saved, setSaved] = useState(false);
  const existing = useResource(async () => {
    try {
      const p = await request<Preference>(`/user-preferences/user/${session!.user.id}`);
      if (p) {
        setId(p.id);
        setStyle(p.preferredStyle || 'Thư giãn');
        setBudget(String(p.maxBudget || 5000000));
        setRegion(p.preferredRegion || 'Việt Nam');
      }
      return p;
    } catch (e) {
      if ((e as any).status === 404) return null;
      throw e;
    }
  }, [request]);
  const save = async () => {
    setBusy(true);
    setError('');
    try {
      const result = await request<Preference>(
        id ? `/user-preferences/${id}` : '/user-preferences',
        id ? 'PUT' : 'POST',
        {
          preferredStyle: style,
          preferredRegion: region,
          maxBudget: positiveNumber(budget, 'Ngân sách', true),
          favoriteCategories: style,
        },
      );
      setId(result.id);
      setSaved(true);
    } catch (e) {
      setError(errorText(e));
    } finally {
      setBusy(false);
    }
  };
  return (
    <View style={{ flex: 1 }}>
      <Header title="Gu du lịch của bạn" back={back} />
      <ScrollView contentContainerStyle={S.page}>
        <Text style={S.title}>Có người thích đi xa.{'\n'}Bạn thích đi thế nào?</Text>
        <Text style={S.body}>
          AI sẽ dùng những sở thích này để gợi ý một chuyến đi gần với bạn hơn.
        </Text>
        <View style={[S.row, { flexWrap: 'wrap' }]}>
          {['Thư giãn', 'Khám phá', 'Ẩm thực', 'Văn hóa', 'Thiên nhiên', 'Mạo hiểm'].map((s) => (
            <Pill
              key={s}
              selected={style === s}
              onPress={() => {
                setStyle(s);
                setSaved(false);
              }}
            >
              {s}
            </Pill>
          ))}
        </View>
        <Field
          label="Ngân sách thường dùng (VNĐ)"
          value={budget}
          onChangeText={setBudget}
          keyboardType="number-pad"
        />
        <Field label="Vùng đất yêu thích" value={region} onChangeText={setRegion} />
        <ErrorBox message={existing.error} retry={existing.reload} />
        <ErrorBox message={error} />
        {saved && <Text style={[S.body, { color: C.green }]}>Đã lưu gu du lịch của bạn.</Text>}
        <Button busy={busy || existing.loading} disabled={!!existing.error} onPress={save}>
          Lưu sở thích
        </Button>
      </ScrollView>
    </View>
  );
}
