import React, { useState, useRef, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableWithoutFeedback,
  Dimensions,
  SafeAreaView,
  TouchableOpacity,
} from 'react-native';

const { width: SCREEN_WIDTH, height: SCREEN_HEIGHT } = Dimensions.get('window');
const PLAYER_SIZE = 40;
const OBSTACLE_WIDTH = 80;
const OBSTACLE_GAP = 160;
const GRAVITY = 0.6;
const JUMP_STRENGTH = -10;

const CHARACTER_EMOJIS = {
  bird: '🐦',
  cube: '🟦',
  rocket: '🚀',
  ball: '⚽',
  cat: '🐱',
};

const THEME_COLORS = {
  sky: ['#3366CC', '#1A3380'],
  space: ['#0D0033', '#1A004D'],
  neon: ['#1A3366', '#4D0066'],
};

export default function GameScreen({ route, navigation }) {
  const { character, theme, gameName } = route.params;

  const [playerY, setPlayerY] = useState(SCREEN_HEIGHT / 2);
  const [velocity, setVelocity] = useState(0);
  const [obstacles, setObstacles] = useState([]);
  const [score, setScore] = useState(0);
  const [gameActive, setGameActive] = useState(true);
  const [gameOver, setGameOver] = useState(false);

  const gameLoopRef = useRef(null);
  const obstacleIdRef = useRef(0);

  useEffect(() => {
    startGame();
    return () => {
      if (gameLoopRef.current) clearInterval(gameLoopRef.current);
    };
  }, []);

  const startGame = () => {
    setPlayerY(SCREEN_HEIGHT / 2);
    setVelocity(0);
    setObstacles([]);
    setScore(0);
    setGameActive(true);
    setGameOver(false);

    gameLoopRef.current = setInterval(() => {
      updateGame();
    }, 16);
  };

  const stopGame = () => {
    setGameActive(false);
    setGameOver(true);
    if (gameLoopRef.current) clearInterval(gameLoopRef.current);
  };

  const updateGame = () => {
    setVelocity((v) => v + GRAVITY);
    setPlayerY((y
