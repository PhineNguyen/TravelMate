import React, { useState } from 'react';
import { KeyboardAvoidingView, Platform, Pressable, ScrollView, Text, View } from 'react-native';
import { useApp } from '../store';
import { Button, C, Cover, ErrorBox, Field, Icon, IconButton, S } from '../ui';
import { destinations } from '../demo';
import { errorText } from '../lib';
import type { Session } from '../types';

export function AuthScreen() {
  const app = useApp();
  const [mode, setMode] = useState<
    'welcome' | 'login' | 'register' | 'forgot' | 'reset' | 'settings'
  >('welcome');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [token, setToken] = useState('');
  const [server, setServer] = useState(app.baseUrl);
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);
  const [notice, setNotice] = useState('');
  const change = (m: typeof mode) => {
    setMode(m);
    setError('');
    setNotice('');
  };
  const submit = async () => {
    setError('');
    setBusy(true);
    try {
      if (mode === 'settings') {
        await app.setBaseUrl(server);
        setNotice('Đã lưu địa chỉ máy chủ.');
        return;
      }
      if (mode !== 'reset' && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim()))
        throw new Error('Nhập một địa chỉ email hợp lệ nhé.');
      if (mode === 'forgot') {
        await app.request('/auth/forgot-password', 'POST', { email: email.trim() });
        change('reset');
        setNotice('Yêu cầu đã được gửi. Kiểm tra email để lấy mã đặt lại mật khẩu.');
        return;
      }
      if ((mode === 'register' || mode === 'reset') && !/^(?=.*[A-Z])(?=.*\d).{8,}$/.test(password))
        throw new Error('Mật khẩu cần ít nhất 8 ký tự, gồm chữ hoa và số.');
      if (mode === 'reset') {
        if (!token.trim()) throw new Error('Nhập mã xác nhận từ email.');
        await app.request('/auth/reset-password', 'POST', {
          resetToken: token.trim(),
          newPassword: password,
        });
        change('login');
        setNotice('Đã đổi mật khẩu. Đăng nhập để tiếp tục.');
        return;
      }
      if (!password || (mode === 'register' && !name.trim()))
        throw new Error('Bạn điền đầy đủ thông tin nhé.');
      const result = await app.request<Session>(`/auth/${mode}`, 'POST', {
        email: email.trim(),
        password,
        ...(mode === 'register' ? { fullName: name.trim() } : {}),
      });
      await app.setSession(result);
    } catch (e) {
      setError(errorText(e));
    } finally {
      setBusy(false);
    }
  };
  if (mode === 'welcome')
    return (
      <ScrollView contentContainerStyle={{ padding: 20, gap: 24 }} bounces={false}>
        <View style={[S.between, { paddingVertical: 8 }]}>
          <View style={S.row}>
            <View style={{ backgroundColor: C.green, borderRadius: 13, padding: 9 }}>
              <Icon name="navigate" color={C.lime} size={22} />
            </View>
            <Text style={{ fontFamily: 'DMBold', fontSize: 22, color: C.ink }}>
              travelmate<Text style={{ color: '#96AE67' }}>.</Text>
            </Text>
          </View>
          <IconButton
            name="options-outline"
            label="Cài đặt kết nối"
            onPress={() => change('settings')}
          />
        </View>
        <Cover uri={destinations[1].image} height={370}>
          <View
            style={{
              position: 'absolute',
              top: 20,
              left: 20,
              backgroundColor: '#FFFFFFE6',
              borderRadius: 20,
              paddingHorizontal: 13,
              paddingVertical: 8,
              flexDirection: 'row',
              gap: 6,
            }}
          >
            <Icon name="leaf-outline" size={14} />
            <Text style={{ fontFamily: 'DMBold', color: C.ink, fontSize: 10, letterSpacing: 1 }}>
              ĐI XA. SỐNG CHẬM.
            </Text>
          </View>
          <View style={{ position: 'absolute', bottom: 26, left: 25, right: 25, gap: 8 }}>
            <Text style={{ fontFamily: 'Playfair', fontSize: 43, lineHeight: 49, color: 'white' }}>
              Thế giới rộng.{'\n'}Đi cùng nhau.
            </Text>
            <Text style={{ fontFamily: 'DM', color: '#E8EEE7', fontSize: 13 }}>
              Một hành trình mới, một câu chuyện của riêng bạn.
            </Text>
          </View>
        </Cover>
        <View style={{ gap: 8, alignItems: 'center' }}>
          <Text style={[S.heading, { fontSize: 22 }]}>Ít lo kế hoạch. Thêm nhiều kỷ niệm.</Text>
          <Text style={[S.body, { textAlign: 'center' }]}>
            Lên lịch trình, giữ ngân sách và khám phá cùng{'\n'}người bạn đồng hành AI của bạn.
          </Text>
        </View>
        <View style={{ gap: 10 }}>
          <Button icon="arrow-forward" onPress={() => change('register')}>
            Bắt đầu hành trình
          </Button>
          <Button secondary onPress={() => change('login')}>
            Mình đã có tài khoản
          </Button>
          <Pressable
            accessibilityRole="button"
            onPress={() => {
              void app.startDemo().catch((e) => setError(errorText(e)));
            }}
            style={{ padding: 14 }}
          >
            <Text
              style={{ textAlign: 'center', fontFamily: 'DMBold', fontSize: 12, color: C.muted }}
            >
              Khám phá bản trải nghiệm ↗
            </Text>
          </Pressable>
          <ErrorBox message={error} />
        </View>
      </ScrollView>
    );
  const titles = {
    login: 'Chào bạn trở lại.',
    register: 'Bắt đầu một điều mới.',
    forgot: 'Mình giúp bạn nhé.',
    reset: 'Một khởi đầu mới.',
    settings: 'Kết nối TravelMate.',
  };
  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
    >
      <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={[S.page, { gap: 25 }]}>
        <IconButton name="arrow-back" label="Quay lại" onPress={() => change('welcome')} />
        <View style={{ paddingTop: 24, gap: 12 }}>
          <Text style={S.label}>TRAVELMATE / YOUR NEXT CHAPTER</Text>
          <Text style={S.title}>{titles[mode]}</Text>
          <Text style={S.body}>
            {mode === 'settings'
              ? 'Dùng IP máy chạy backend khi kết nối từ điện thoại cùng Wi-Fi.'
              : 'Những hành trình đáng nhớ đang chờ bạn.'}
          </Text>
        </View>
        {mode === 'settings' ? (
          <Field
            label="Địa chỉ backend"
            value={server}
            onChangeText={setServer}
            autoCapitalize="none"
            placeholder="http://192.168.1.10:8080"
          />
        ) : (
          <View style={{ gap: 18 }}>
            {mode === 'register' && (
              <Field
                label="Tên của bạn"
                value={name}
                onChangeText={setName}
                placeholder="Bạn muốn được gọi là gì?"
                autoComplete="name"
              />
            )}
            {mode !== 'reset' && (
              <Field
                label="Email"
                value={email}
                onChangeText={setEmail}
                placeholder="ban@example.com"
                keyboardType="email-address"
                autoCapitalize="none"
                autoComplete="email"
              />
            )}
            {mode === 'reset' && (
              <Field
                label="Mã xác nhận từ email"
                value={token}
                onChangeText={setToken}
                autoCapitalize="none"
              />
            )}
            {mode !== 'forgot' && (
              <Field
                label={mode === 'reset' ? 'Mật khẩu mới' : 'Mật khẩu'}
                value={password}
                onChangeText={setPassword}
                secureTextEntry
                placeholder={
                  mode === 'register' ? 'Ít nhất 8 ký tự, chữ hoa và số' : 'Nhập mật khẩu của bạn'
                }
                autoComplete={mode === 'login' ? 'current-password' : 'new-password'}
              />
            )}
            {mode === 'login' && (
              <Pressable onPress={() => change('forgot')}>
                <Text
                  style={{ fontFamily: 'DMBold', color: C.green, textAlign: 'right', padding: 6 }}
                >
                  Quên mật khẩu?
                </Text>
              </Pressable>
            )}
          </View>
        )}
        <ErrorBox message={error} />
        {notice ? (
          <Text accessibilityRole="alert" style={[S.body, { color: C.green }]}>
            {notice}
          </Text>
        ) : null}
        <Button busy={busy} onPress={submit}>
          {mode === 'settings'
            ? 'Lưu kết nối'
            : mode === 'forgot'
              ? 'Gửi email khôi phục'
              : mode === 'reset'
                ? 'Đặt lại mật khẩu'
                : mode === 'login'
                  ? 'Đăng nhập'
                  : 'Tạo tài khoản'}
        </Button>
        {(mode === 'register' || mode === 'login') && (
          <Pressable onPress={() => change(mode === 'login' ? 'register' : 'login')}>
            <Text style={[S.body, { textAlign: 'center', color: C.green }]}>
              {mode === 'login' ? 'Chưa có tài khoản? Đăng ký' : 'Đã có tài khoản? Đăng nhập'}
            </Text>
          </Pressable>
        )}
      </ScrollView>
    </KeyboardAvoidingView>
  );
}
