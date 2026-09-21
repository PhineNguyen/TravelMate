import React, { useEffect, useState } from 'react';
import { BackHandler, Platform, Pressable, StyleSheet, Text, View } from 'react-native';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { useFonts } from 'expo-font';
import { DMSans_400Regular } from '@expo-google-fonts/dm-sans/400Regular';
import { DMSans_700Bold } from '@expo-google-fonts/dm-sans/700Bold';
import { PlayfairDisplay_500Medium } from '@expo-google-fonts/playfair-display/500Medium';
import { AppProvider, useApp } from './src/store';
import { AuthScreen } from './src/screens/Auth';
import { ExploreScreen, TripsScreen } from './src/screens/Explore';
import { CreateTripScreen } from './src/screens/CreateTrip';
import { TripDetailScreen } from './src/screens/TripDetail';
import { AssistantScreen } from './src/screens/Assistant';
import { PreferencesScreen, ProfileScreen } from './src/screens/Profile';
import { C, Icon, Loading } from './src/ui';
import type { Route } from './src/navigation';
import type { Trip } from './src/types';

function Shell() {
  const { ready, session } = useApp();
  if (!ready) return <Loading />;
  return session ? <SignedIn key={session.demo ? 'demo' : session.user.id} /> : <AuthScreen />;
}
function SignedIn() {
  const { session } = useApp();
  const [tab, setTab] = useState('explore');
  const [route, setRoute] = useState<Route>({ name: 'tabs' });
  const [chatTrip, setChatTrip] = useState<Trip>();
  const back = () => setRoute({ name: 'tabs' });
  const chat = (trip: Trip) => {
    setChatTrip(trip);
    setTab('ai');
    back();
  };
  useEffect(() => {
    const sub = BackHandler.addEventListener('hardwareBackPress', () => {
      if (route.name !== 'tabs') {
        back();
        return true;
      }
      if (tab !== 'explore') {
        setTab('explore');
        return true;
      }
      return false;
    });
    return () => sub.remove();
  }, [route, tab]);
  const tabs = [
    { id: 'explore', label: 'Khám phá', icon: 'compass-outline', active: 'compass' },
    { id: 'trips', label: 'Hành trình', icon: 'map-outline', active: 'map' },
    { id: 'ai', label: 'Bạn AI', icon: 'sparkles-outline', active: 'sparkles' },
    { id: 'profile', label: 'Cá nhân', icon: 'person-outline', active: 'person' },
  ] as const;
  return (
    <View style={{ flex: 1 }}>
      {session?.demo && (
        <View style={{ backgroundColor: '#EAF0DE', paddingVertical: 5, alignItems: 'center' }}>
          <Text style={{ fontFamily: 'DM', fontSize: 9, color: C.green, letterSpacing: 0.6 }}>
            BẢN TRẢI NGHIỆM · DỮ LIỆU MẪU
          </Text>
        </View>
      )}
      <View style={{ flex: 1, minHeight: 0 }}>
        {route.name === 'create' ? (
          <CreateTripScreen
            route={route}
            back={back}
            created={(trip) => {
              setTab('trips');
              setRoute({ name: 'trip', trip });
            }}
          />
        ) : route.name === 'trip' ? (
          <TripDetailScreen initialTrip={route.trip} back={back} chat={chat} />
        ) : route.name === 'preferences' ? (
          <PreferencesScreen back={back} />
        ) : tab === 'explore' ? (
          <ExploreScreen
            navigate={setRoute}
            goTrips={() => setTab('trips')}
            goAI={() => setTab('ai')}
            goProfile={() => setTab('profile')}
          />
        ) : tab === 'trips' ? (
          <TripsScreen navigate={setRoute} />
        ) : tab === 'ai' ? (
          <AssistantScreen initialTrip={chatTrip} createTrip={() => setRoute({ name: 'create' })} />
        ) : (
          <ProfileScreen preferences={() => setRoute({ name: 'preferences' })} />
        )}
      </View>
      {route.name === 'tabs' && (
        <View
          style={{
            flexDirection: 'row',
            paddingHorizontal: 15,
            paddingTop: 11,
            paddingBottom: 10,
            borderTopWidth: 1,
            borderColor: C.line,
            backgroundColor: C.bg,
          }}
        >
          {tabs.map((t) => (
            <Pressable
              key={t.id}
              accessibilityRole="tab"
              accessibilityState={{ selected: tab === t.id }}
              accessibilityLabel={t.label}
              onPress={() => setTab(t.id)}
              style={{ flex: 1, alignItems: 'center', gap: 5, minHeight: 48 }}
            >
              <View
                style={{
                  paddingHorizontal: 16,
                  paddingVertical: 5,
                  borderRadius: 16,
                  backgroundColor: tab === t.id ? C.soft : 'transparent',
                }}
              >
                <Icon
                  name={tab === t.id ? t.active : t.icon}
                  size={22}
                  color={tab === t.id ? C.green : C.muted}
                />
              </View>
              <Text
                style={{
                  fontFamily: tab === t.id ? 'DMBold' : 'DM',
                  fontSize: 10,
                  color: tab === t.id ? C.green : C.muted,
                }}
              >
                {t.label}
              </Text>
            </Pressable>
          ))}
        </View>
      )}
    </View>
  );
}
export default function App() {
  const [loaded, error] = useFonts({
    DM: DMSans_400Regular,
    DMBold: DMSans_700Bold,
    Playfair: PlayfairDisplay_500Medium,
  });
  return (
    <SafeAreaProvider>
      <View style={{ flex: 1, backgroundColor: '#E5E9E1', alignItems: 'center' }}>
        <SafeAreaView
          style={{
            flex: 1,
            width: '100%',
            maxWidth: 480,
            backgroundColor: C.bg,
            overflow: 'hidden',
            ...(Platform.OS === 'web' ? { boxShadow: '0 0 80px #263A2310' } : {}),
          }}
        >
          <StatusBar style="dark" />
          {!loaded && !error ? (
            <Loading />
          ) : (
            <AppProvider>
              <Shell />
            </AppProvider>
          )}
        </SafeAreaView>
      </View>
    </SafeAreaProvider>
  );
}
