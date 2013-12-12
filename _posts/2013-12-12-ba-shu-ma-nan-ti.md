---
layout: post
title: 八数码难题
subheading: 状态空间搜索
categories: 算法
author: CodeCatalyst
---

### 问题描述

## 给定一个3×3的矩阵，其元素为8个不同的数码，起始状态为S0，目标状态为Sg。对任意给定的初始状态，并非都可以变换到有规律的最终状态。要求在算法实现过程中，能判断出是否可以变换到最终状态。如果不行，输出null，如果可以，用两种或以上的方法设计优先队列式分支限界法，寻找从初始状态变换到目标状态的最优解，说明不同的优先选择策略变换到最终状态用了多少步，并对获得的结果做出比较分析。最终状态均如Sg表示。

代码如下.

~~~java
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Scanner;
import java.util.Vector;

public class EightNumber {

  private static State sourceState;
  private static State targetState;
  private static State[] line;
  private static int first;
  private static int last;
  private final static int[][] move = { { 0, 1 }, { 1, 0 }, { 0, -1 },
      { -1, 0 } };
  private Vector<String> histories;
  private final static int N = 10000000;

  EightNumber() {
    sourceState = new State();
    int[][] targetArr = { { 1, 2, 3 }, { 8, 0, 4 }, { 7, 6, 5 } };
    targetState = new State(targetArr);
    line = new State[N];
    first = 0;
    last = 0;
    histories = new Vector<String>();
  }// end constructor

  public void insertState(State state) {
    if (first == last) {
      line[first] = state;
      ++last;
    } else {
      int i = last - 1;
      for (; i > first; i--) {
        if (state.countOfNotInP < line[i].countOfNotInP) {
          line[i + 1] = line[i];
        }// end if
        else {
          break;
        }
      }// end for
      line[i + 1] = state;
      last = (++last) % N;
    }
  }

  public void readSourceState() {
    try {
      Scanner input = new Scanner(new File("input71.txt"));
      for (int i = 0; i < 3; i++) {
        for (int k = 0; k < 3; k++) {
          sourceState.states[i][k] = input.nextInt();
        }
      }
      countNotInPosition(sourceState);
      sourceState.fatherState = null;
      insertState(sourceState);
      histories.add(sourceState.getStates());
      printState(sourceState);
    } catch (FileNotFoundException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
  }// end readSourceState

  public void BFS() {
    while (last != first) {
      expendCurrentState(line[first]);
      first = (++first) % N;
    }
    try {
      System.setOut(new PrintStream(new File("output72.txt")));
    } catch (FileNotFoundException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    System.out.println("No Solution!");// 队列为空，找不到解决办法
  }// end BFS

  public void expendCurrentState(State state) {
    State currentState = null;
    int x = 0;
    int y = 0;
    for (int i = 0; i < 3; i++) {
      for (int k = 0; k < 3; k++) {
        currentState = new State(state);
        for (int countForDir = 0; countForDir < 4; countForDir++) {
          x = i + move[countForDir][0];
          y = k + move[countForDir][1];
          if (contain(x, y)) {// 在范围内
            if (currentState.states[x][y] == 0) {
              currentState.states[x][y] = currentState.states[i][k];
              currentState.states[i][k] = 0;
              if (!histories.contains(currentState.getStates())) {
                countNotInPosition(currentState);
                currentState.fatherState = state;
                insertState(currentState);
                histories.add(currentState.getStates());
              }
              if (currentState.countOfNotInP == 0) {// 找到
                try {
                  System.setOut(new PrintStream(new File(
                      "output72.txt")));
                } catch (FileNotFoundException e) {
                  // TODO Auto-generated catch block
                  e.printStackTrace();
                }
                printState(currentState);
                System.exit(0);
              }
            }// end if ==0
          }// end if contain
        }
      }
    }
  }

  public boolean contain(int x, int y) {
    if (x >= 0 && x < 3 && y >= 0 && y < 3)
      return true;
    return false;
  }

  public void countNotInPosition(State state) {
    state.countOfNotInP = 0;
    for (int i = 0; i < 3; i++) {
      for (int k = 0; k < 3; k++) {
        if (state.states[i][k] != targetState.states[i][k]) {
          if (i == 1 && k == 1)
            continue;
          else
            ++state.countOfNotInP;
        }
      }
    }
  }// end countNotInPosition

  public boolean canMoveToCenter(State state, int x, int y) {
    if (state.states[1][1] == 0)
      if (x == 1 || y == 1)
        return true;
    return false;
  }// end canMove

  public void printState(State state) {
    if (state.fatherState != null)
      printState(state.fatherState);
    System.out.println(state.getStates().substring(0, 3) + "\n"
        + state.getStates().substring(3, 6) + "\n"
        + state.getStates().substring(6, 9));
    System.out.println("CountOfNotInPosition:" + state.countOfNotInP);
  }// end printState

  public static void main(String[] args) {
    // TODO Auto-generated method stub

    EightNumber eightNumber = new EightNumber();
    eightNumber.readSourceState();
    eightNumber.BFS();
    // eightNumber.expendCurrentState(line[first]);
  }

  class State {
    final static int N = 3;
    int[][] states;// 3×3矩阵
    int countOfNotInP;// 保存不在位数
    State fatherState;

    State() {
      states = new int[N][N];
      countOfNotInP = 0;
    }

    State(int[][] states) {
      this.states = new int[N][N];
      if (states.length == N)
        this.states = states;
    }

    State(State state) {
      this.states = new int[N][N];
      for (int row = 0; row < N; row++) {
        for (int coloum = 0; coloum < N; coloum++) {
          this.states[row][coloum] = state.states[row][coloum];
        }
      }
      this.countOfNotInP = state.countOfNotInP;
    }

    String getStates() {
      StringBuilder sb = new StringBuilder();
      for (int i[] : states) {
        for (int k : i) {
          sb.append(k);
        }
      }
      return sb.toString();
    }
  }
}
~~~




