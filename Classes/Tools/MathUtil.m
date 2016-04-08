//
//  MathUtil.m
//  ydtctz
//
//  Created by 小宝 on 1/17/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "MathUtil.h"

/**
 * 排列算法。计算排列的结果个数
 *
 * @param m 总数
 * @param n 选取的个数
 * @return 结果个数
 */
int permutation(int m, int n) {
    if ((m == 0) || (n == 0)) {
        return 0;
    }
    if (m < n) {
        return 0;
    }
    int r = 1;
    for (int i = 0; i < n; i++) {
        r = r * (m - i);
    }
    return r;
}

/**
 * 计算排列算法中，如果可以重复时总的结果个数
 * @param m 总数
 * @param n 选取的个数
 * @return 结果个数
 */
int permutationRepeatable(int m, int n) {
    if ((m == 0) || (n == 0)) {
        return 0;
    }
    if (m < n) {
        return 0;
    }
    int r = 1;
    for (int i = 0; i < n; i++) {
        r = r * m;
    }
    return r;
}

/**
 * 组合算法。计算组合的结果个数
 *
 * @param m 总数
 * @param n 选取的个数
 * @return 结果个数
 */
int combination(int m, int n) {
    if ((m == 0) || (n == 0)) {
        return 0;
    }
    if (m < n) {
        return 0;
    }
    int r = 1;
    for (int i = 0; i < n; i++) {
        r = r * (m - i);
    }
    for (int i = n; i > 1; i--) {
        r = r / (i);
    }
    return r;
}

/**
 * 计算幸运赛车前三胆拖注数
 *
 * @param dan
 * @param tuo
 * @return
 */
int calcXyscThreeDanTuo(int dan, int tuo) {
    if (dan < 1 || dan + tuo < 4)
        return 0;
    
    if (dan == 1)
        return 3 * tuo * (tuo - 1);
    else if (dan == 2)
        return 6 * tuo;
    
    return 0;
}

/**
 * 计算幸运赛车前二胆拖注数
 *
 * @param dan
 * @param tuo
 * @return
 */
int calcXyscTwoDanTuo(int dan, int tuo) {
    if (dan + tuo < 3)
        return 0;
    
    return 2*dan*tuo;
}

/**
 * 计算幸运赛车组二胆拖注数
 *
 * @param dan
 * @param tuo
 * @return
 */
int calcXyscZu2DanTuo(int dan, int tuo) {
    if (dan + tuo < 3)
        return 0;

    return dan*tuo;
}

/**
 * 计算幸运赛车组三胆拖注数
 *
 * @param dan
 * @param tuo
 * @return
 */
int calcXyscZu3DanTuo(int dan, int tuo) {
    if (dan < 1 || dan + tuo < 4)
        return 0;
    
    if (dan == 1)
        return combination(tuo,2);
    else if (dan == 2)
        return tuo;
    
    return 0;
}

float angleToDegree(float angle){
    return angle * 180.0f / M_PI;
}
