import React, { useState } from 'react';
import { Modal, Pressable, Text, View } from 'react-native';
import { Button, C, Icon, IconButton, S } from '../ui';

export function toLocalDate(date: Date) {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

export function DatePicker({
  label,
  value,
  onChange,
  minimum,
}: {
  label: string;
  value: string;
  onChange: (date: string) => void;
  minimum?: string;
}) {
  const [open, setOpen] = useState(false);
  const [month, setMonth] = useState(() => new Date(`${value}T12:00:00`));
  const [selected, setSelected] = useState(value);
  const year = month.getFullYear();
  const index = month.getMonth();
  const offset = (new Date(year, index, 1).getDay() + 6) % 7;
  const count = new Date(year, index + 1, 0).getDate();
  return (
    <View style={{ gap: 8, flex: 1 }}>
      <Text style={{ fontFamily: 'DMBold', fontSize: 12, color: C.ink }}>{label}</Text>
      <Pressable
        accessibilityRole="button"
        accessibilityLabel={`${label}: ${value}`}
        onPress={() => {
          setSelected(value);
          setMonth(new Date(`${value}T12:00:00`));
          setOpen(true);
        }}
        style={[S.field, S.between, { paddingHorizontal: 12 }]}
      >
        <Text style={{ fontFamily: 'DM', fontSize: 13, color: C.ink }}>
          {new Date(`${value}T12:00:00`).toLocaleDateString('vi-VN')}
        </Text>
        <Icon name="calendar-outline" size={17} color={C.green} />
      </Pressable>
      <Modal visible={open} transparent animationType="fade" onRequestClose={() => setOpen(false)}>
        <View
          style={{
            flex: 1,
            backgroundColor: '#17352B99',
            justifyContent: 'center',
            alignItems: 'center',
            padding: 20,
          }}
        >
          <View
            accessibilityViewIsModal
            style={{
              width: '100%',
              maxWidth: 390,
              backgroundColor: C.bg,
              borderRadius: 28,
              padding: 20,
              gap: 20,
            }}
          >
            <View style={S.between}>
              <Text style={S.heading}>{label}</Text>
              <IconButton name="close" label="Đóng lịch" onPress={() => setOpen(false)} />
            </View>
            <View style={S.between}>
              <IconButton
                name="chevron-back"
                label="Tháng trước"
                onPress={() => setMonth(new Date(year, index - 1, 1))}
              />
              <Text style={{ fontFamily: 'DMBold', color: C.ink }}>
                Tháng {index + 1}, {year}
              </Text>
              <IconButton
                name="chevron-forward"
                label="Tháng sau"
                onPress={() => setMonth(new Date(year, index + 1, 1))}
              />
            </View>
            <View style={{ flexDirection: 'row' }}>
              {['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'].map((d) => (
                <Text
                  key={d}
                  style={{
                    width: '14.285%',
                    textAlign: 'center',
                    fontFamily: 'DM',
                    fontSize: 12,
                    color: C.muted,
                  }}
                >
                  {d}
                </Text>
              ))}
            </View>
            <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
              {Array.from({ length: offset + count }, (_, cell) => {
                const day = cell - offset + 1;
                if (day < 1) return <View key={cell} style={{ width: '14.285%', height: 44 }} />;
                const date = toLocalDate(new Date(year, index, day));
                const disabled = !!minimum && date < minimum;
                return (
                  <Pressable
                    key={cell}
                    accessibilityRole="button"
                    accessibilityLabel={`Ngày ${day} tháng ${index + 1} năm ${year}`}
                    accessibilityState={{ selected: date === selected, disabled }}
                    disabled={disabled}
                    onPress={() => setSelected(date)}
                    style={{ width: '14.285%', height: 44, padding: 2 }}
                  >
                    <View
                      style={{
                        flex: 1,
                        alignItems: 'center',
                        justifyContent: 'center',
                        borderRadius: 20,
                        backgroundColor: date === selected ? C.green : 'transparent',
                        opacity: disabled ? 0.25 : 1,
                      }}
                    >
                      <Text
                        style={{
                          fontFamily: 'DMBold',
                          color: date === selected ? C.white : C.ink,
                          fontSize: 13,
                        }}
                      >
                        {day}
                      </Text>
                    </View>
                  </Pressable>
                );
              })}
            </View>
            <Button
              disabled={!!minimum && selected < minimum}
              onPress={() => {
                onChange(selected);
                setOpen(false);
              }}
            >
              Chọn ngày này
            </Button>
          </View>
        </View>
      </Modal>
    </View>
  );
}
