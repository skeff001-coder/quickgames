import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  Share,
  Clipboard,
} from 'react-native';

const FRIEND_BEST = 456;
const FRIEND_NAME = 'Alex';

export default function ShareScreen({ route }) {
  const { score, gameName } = route.params;
  const [copied, setCopied] = useState(false);

  const shareLink = `https://quickgames.app/share/${Math.random().toString(36).substring(7)}`;

  const handleCopyLink = () => {
    Clipboard.setString(shareLink);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleNativeShare = async () => {
    try {
      await Share.share({
        message: `I scored ${score} in ${gameName}! Can you beat it? ${shareLink}`,
      });
    } catch (error) {
      console.log(error);
    }
  };

  const isAhead = score > FRIEND_BEST;

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView showsVerticalScrollIndicator={false}>
        
