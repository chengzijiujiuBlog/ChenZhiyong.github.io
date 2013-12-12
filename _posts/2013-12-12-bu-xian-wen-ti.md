---
layout: post
title: 布线问题
subheading: 状态空间搜索
categories: 算法
author: CodeCatalyst
---

### 问题描述

## 实验要求：请在下图所给出电路板中，按布线要求，利用分支限界法实现从a到b的布线工作。此处坐标为a(1,2),b(6,3)。
布线问题
实验要求：给出解空间的定义组织形式、剪枝函数设计方案和实现程序，output.txt文件中给出布线方案。
在测试数据中，任意给定a、b两点的坐标，请输出相应布线方案。

代码如下.

~~~java
import java.util.Scanner;

public class SetLine {
	private final static int N = 8;
	private final static int[][] move = { { 0, -1 }, { 1, 0 }, { 0, 1 },
			{ -1, 0 } };
	private final static int[][] board = { { 0, 0, 0, -1, -1, 0, 0, 0 },
			{ 0, 0, 0, -1, -1, 0, 0, 0 }, { 0, 0, 0, -1, -1, 0, 0, 0 },
			{ 0, 0, 0, -1, -1, 0, 0, 0 }, { 0, 0, 0, -1, -1, 0, 0, 0 },
			{ 0, 0, 0, 0, 0, 0, -1, -1 }, { 0, 0, 0, 0, 0, 0, -1, -1 },
			{ 0, 0, 0, 0, 0, 0, -1, -1 }, };
	private static Point a;
	private static Point b;
	private static Point[] line;
	private static int first;
	private static int last;

	SetLine() {
		line = new Point[2 * N];
		for (int i = 0; i < 2 * N; i++) {
			line[i] = new Point();
		}
		first = 0;
		last = 0;
		a = new Point();
		a.nextt = 1;
		b = new Point();
	}

	public void setLine(Point p) {
		Point temp = new Point();
		while (first != last) {
			for (int i = 0; i < 4; i++) {
				temp.x = line[first].x + move[i][0];
				temp.y = line[first].y + move[i][1];
				if (contain(temp) && isValid(temp)) {
					setPoint(temp, line[first].nextt);
					if (temp.x == b.x && temp.y == b.y) {
						board[b.x][b.y] = 98;
						return;
					}
				}// end if
			}// end for
			line[first] = new Point();
			first = (++first) % (2 * N);
		}// end while
	}

	public void setPoint(Point p, int t) {
		line[last].x = p.x;
		line[last].y = p.y;
		line[last].nextt = t + 1;
		last = (++last) % (2 * N);
		board[p.x][p.y] = t;
	}

	public boolean contain(Point p) {
		if (p.x >= 0 && p.x < 8 && p.y >= 0 && p.y < 8)
			return true;
		return false;
	}

	public boolean isValid(Point p) {
		if (board[p.x][p.y] == 0)
			return true;
		return false;
	}

	public void print() {
		for (int i = 0; i < N; i++) {
			for (int k = 0; k < N; k++) {
				if (board[i][k] == 97 || board[i][k] == 98)
					System.out.format("%-5s", (char) board[i][k]);
				else
					System.out.format("%-5d", board[i][k]);
			}
			System.out.println();
		}
	}

	public static boolean isOk(Point p) {
		if (p.x < 0 || p.x >= 8)
			return false;
		if (p.y < 0 || p.y >= 8)
			return false;
		if (p.x <= 4 && p.y >= 3 && p.y <= 4)
			return false;
		if (p.x >= 5 && p.y >= 6)
			return false;
		return true;
	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		SetLine sl = new SetLine();
		Scanner input = new Scanner(System.in);
		sl.print();
		while (true) {
			System.out.print("Input A:");
			a.x = input.nextInt();
			a.y = input.nextInt();
			if (isOk(a)) {
				break;
			} else {
				System.out.println("输入错误！");
			}
		}

		while (true) {
			System.out.print("Input B:");
			b.x = input.nextInt();
			b.y = input.nextInt();
			if (isOk(b)) {
				break;
			} else {
				System.out.println("输入错误！");
			}
		}
		board[a.x][a.y] = 97;
		line[last++] = a;
		sl.setLine(a);
		sl.print();
	}

	class Point {
		int x;
		int y;
		int nextt;

		Point() {
			x = 0;
			y = 0;
			nextt = 0;
		}

		Point(int x, int y) {
			this.x = x;
			this.y = y;
		}
	}
}

~~~




