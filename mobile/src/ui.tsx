import React, { useState } from 'react';
import {
  ActivityIndicator,
  Image,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TextInputProps,
  View,
  ViewStyle,
} from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import { LinearGradient } from 'expo-linear-gradient';
export const C = {
  bg: '#FAF9F5',
  ink: '#203C33',
  green: '#245D49',
  lime: '#DCECAB',
  muted: '#7C827B',
  line: '#E7E8E0',
  white: '#FFFFFF',
  soft: '#EEF1E8',
  red: '#B84938',
  sand: '#EEE5D5',
};
export const S = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  between: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', gap: 12 },
  page: { padding: 24, paddingBottom: 34, gap: 24 },
  title: { fontFamily: 'Playfair', fontSize: 34, lineHeight: 43, color: C.ink },
  heading: { fontFamily: 'DMBold', fontSize: 21, color: C.ink },
  body: { fontFamily: 'DM', fontSize: 14, lineHeight: 22, color: C.muted },
  label: { fontFamily: 'DMBold', fontSize: 10, letterSpacing: 2, color: C.muted },
  card: {
    backgroundColor: C.white,
    padding: 18,
    borderRadius: 22,
    borderWidth: 1,
    borderColor: C.line,
  },
  field: {
    backgroundColor: C.white,
    borderWidth: 1,
    borderColor: C.line,
    borderRadius: 15,
    paddingHorizontal: 16,
    paddingVertical: 15,
    fontFamily: 'DM',
    color: C.ink,
    fontSize: 14,
    minHeight: 50,
  },
});
export function Icon({
  name,
  size = 22,
  color = C.ink,
}: {
  name: React.ComponentProps<typeof Ionicons>['name'];
  size?: number;
  color?: string;
}) {
  return <Ionicons name={name} size={size} color={color} />;
}
export function IconButton({
  name,
  label,
  onPress,
  light = false,
  disabled = false,
}: {
  name: React.ComponentProps<typeof Ionicons>['name'];
  label: string;
  onPress: () => void;
  light?: boolean;
  disabled?: boolean;
}) {
  return (
    <Pressable
      accessibilityRole="button"
      accessibilityLabel={label}
      disabled={disabled}
      onPress={onPress}
      style={({ pressed }) => ({
        width: 44,
        height: 44,
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: 22,
        backgroundColor: light ? '#FFFFFFDD' : C.white,
        opacity: disabled ? 0.35 : pressed ? 0.6 : 1,
        borderWidth: light ? 0 : 1,
        borderColor: C.line,
      })}
    >
      <Icon name={name} />
    </Pressable>
  );
}
export function Button({
  children,
  onPress,
  secondary = false,
  busy = false,
  disabled = false,
  icon,
  style,
  small = false,
}: {
  children: string;
  onPress: () => void;
  secondary?: boolean;
  busy?: boolean;
  disabled?: boolean;
  icon?: React.ComponentProps<typeof Ionicons>['name'];
  style?: ViewStyle;
  small?: boolean;
}) {
  return (
    <Pressable
      accessibilityRole="button"
      accessibilityState={{ disabled: busy || disabled }}
      disabled={busy || disabled}
      onPress={onPress}
      style={({ pressed }) => [
        {
          backgroundColor: secondary ? C.soft : C.green,
          borderRadius: 16,
          minHeight: small ? 42 : 54,
          paddingHorizontal: small ? 16 : 20,
          paddingVertical: 12,
          flexDirection: 'row',
          gap: 10,
          justifyContent: 'center',
          alignItems: 'center',
          opacity: disabled || busy ? 0.6 : pressed ? 0.8 : 1,
        },
        style,
      ]}
    >
      {busy ? (
        <ActivityIndicator color={secondary ? C.green : C.white} />
      ) : (
        <>
          {icon && <Icon name={icon} color={secondary ? C.green : C.white} size={18} />}
          <Text
            style={{ fontFamily: 'DMBold', fontSize: 14, color: secondary ? C.green : C.white }}
          >
            {children}
          </Text>
        </>
      )}
    </Pressable>
  );
}
export function Field({ label, ...props }: TextInputProps & { label: string }) {
  return (
    <View style={{ gap: 8 }}>
      {!!label && <Text style={{ fontFamily: 'DMBold', color: C.ink, fontSize: 12 }}>{label}</Text>}
      <TextInput
        accessibilityLabel={label}
        placeholderTextColor="#A3AAA2"
        {...props}
        style={[
          S.field,
          props.multiline && { minHeight: 90, textAlignVertical: 'top' },
          props.style,
        ]}
      />
    </View>
  );
}
export function Pill({
  children,
  selected,
  onPress,
  icon,
}: {
  children: string;
  selected?: boolean;
  onPress?: () => void;
  icon?: React.ComponentProps<typeof Ionicons>['name'];
}) {
  return (
    <Pressable
      accessibilityRole={onPress ? 'button' : undefined}
      accessibilityState={{ selected }}
      onPress={onPress}
      style={{
        flexDirection: 'row',
        alignItems: 'center',
        gap: 7,
        paddingHorizontal: 16,
        paddingVertical: 11,
        borderRadius: 24,
        backgroundColor: selected ? C.green : C.white,
        borderWidth: 1,
        borderColor: selected ? C.green : C.line,
      }}
    >
      {icon && <Icon name={icon} size={16} color={selected ? C.white : C.ink} />}
      <Text
        style={{
          fontFamily: selected ? 'DMBold' : 'DM',
          fontSize: 12,
          color: selected ? C.white : C.ink,
        }}
      >
        {children}
      </Text>
    </Pressable>
  );
}
export function Section({
  title,
  action,
  onPress,
}: {
  title: string;
  action?: string;
  onPress?: () => void;
}) {
  return (
    <View style={S.between}>
      <Text style={[S.heading, { flex: 1 }]}>{title}</Text>
      {action && (
        <Pressable accessibilityRole="button" onPress={onPress} style={{ paddingVertical: 10 }}>
          <Text style={{ fontFamily: 'DMBold', color: C.green, fontSize: 12 }}>{action} ↗</Text>
        </Pressable>
      )}
    </View>
  );
}
export function ErrorBox({ message, retry }: { message: string; retry?: () => void }) {
  if (!message) return null;
  return (
    <View
      accessibilityRole="alert"
      style={{ backgroundColor: '#FAEBE6', borderRadius: 14, padding: 14, gap: 8 }}
    >
      <Text style={[S.body, { color: C.red }]}>{message}</Text>
      {retry && (
        <Button small secondary onPress={retry}>
          Thử lại
        </Button>
      )}
    </View>
  );
}
export function Empty({
  icon = 'compass-outline',
  title,
  text,
  action,
  onPress,
}: {
  icon?: React.ComponentProps<typeof Ionicons>['name'];
  title: string;
  text: string;
  action?: string;
  onPress?: () => void;
}) {
  return (
    <View style={{ alignItems: 'center', paddingVertical: 28, gap: 12 }}>
      <View style={{ padding: 20, backgroundColor: C.soft, borderRadius: 50 }}>
        <Icon name={icon} size={30} color={C.green} />
      </View>
      <Text style={[S.heading, { textAlign: 'center', fontSize: 18 }]}>{title}</Text>
      <Text style={[S.body, { textAlign: 'center', maxWidth: 290 }]}>{text}</Text>
      {action && onPress && (
        <Button small onPress={onPress}>
          {action}
        </Button>
      )}
    </View>
  );
}
export function Loading() {
  return (
    <View style={{ padding: 36, gap: 12, alignItems: 'center' }}>
      <ActivityIndicator color={C.green} />
      <Text style={S.body}>Đang chuẩn bị hành trình…</Text>
    </View>
  );
}
export function Cover({
  uri,
  children,
  height = 300,
  style,
}: {
  uri: string;
  children?: React.ReactNode;
  height?: number;
  style?: ViewStyle;
}) {
  const [failedUri, setFailedUri] = useState<string>();
  return (
    <View
      style={[{ height, overflow: 'hidden', borderRadius: 25, backgroundColor: '#77978B' }, style]}
    >
      <LinearGradient colors={['#8FAF9C', '#426D59']} style={StyleSheet.absoluteFill} />
      {failedUri !== uri && (
        <Image
          source={{ uri }}
          accessibilityIgnoresInvertColors
          style={StyleSheet.absoluteFill}
          resizeMode="cover"
          onError={() => setFailedUri(uri)}
        />
      )}
      {failedUri === uri && (
        <View style={{ position: 'absolute', top: 28, right: 28 }}>
          <Icon name="leaf-outline" size={38} color="#D9E8C5" />
        </View>
      )}
      <LinearGradient
        colors={['transparent', '#102D258F', '#102D25E8']}
        locations={[0, 0.5, 1]}
        style={StyleSheet.absoluteFill}
      />
      {children}
    </View>
  );
}
export function Header({
  title,
  back,
  right,
}: {
  title: string;
  back: () => void;
  right?: React.ReactNode;
}) {
  return (
    <View style={[S.between, { paddingHorizontal: 20, paddingVertical: 14 }]}>
      <IconButton name="arrow-back" label="Quay lại" onPress={back} />
      <Text style={{ fontFamily: 'DMBold', fontSize: 16, color: C.ink }}>{title}</Text>
      {right || <View style={{ width: 44 }} />}
    </View>
  );
}
