//
//  Font.swift
//  TMT
//
//  Created by 김유빈 on 1/2/25.
//

import SwiftUI

extension Text {
    /// 공통 스타일 적용 함수
    private func applyTextStyle(
        fontName: String,
        fontSize: CGFloat,
        figmaLetterSpacing: CGFloat,
        figmaLineHeight: CGFloat
    ) -> some View {
        let trackingValue = (figmaLetterSpacing / 100) * fontSize
        let lineSpacingValue = max(figmaLineHeight - fontSize - 4, 0)

        return self
            .font(.custom(fontName, size: fontSize))
            .tracking(trackingValue)
            .lineSpacing(lineSpacingValue)
            .padding(.vertical, lineSpacingValue / 2)
            .frame(minHeight: max(figmaLineHeight - 4, fontSize))
    }

    /// Title0-SemiBold
    func title0SemiBold() -> some View {
        applyTextStyle(
            fontName: "Pretendard-SemiBold",
            fontSize: 45,
            figmaLetterSpacing: 0,
            figmaLineHeight: 40
        )
    }

    /// Title1-Bold
    func title1Bold() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Bold",
            fontSize: 28,
            figmaLetterSpacing: -0.2,
            figmaLineHeight: 33.4
        )
    }

    /// Title1-SemiBold
    func title1SemiBold() -> some View {
        applyTextStyle(
            fontName: "Pretendard-SemiBold",
            fontSize: 28,
            figmaLetterSpacing: -0.2,
            figmaLineHeight: 33.4
        )
    }

    /// Title2
    func title2() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Bold",
            fontSize: 24,
            figmaLetterSpacing: -0.2,
            figmaLineHeight: 29
        )
    }

    /// Title3
    func title3() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Bold",
            fontSize: 22,
            figmaLetterSpacing: -0.2,
            figmaLineHeight: 26
        )
    }

    /// Title4
    func title4() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Bold",
            fontSize: 20,
            figmaLetterSpacing: -0.2,
            figmaLineHeight: 26
        )
    }

    /// Title5
    func title5() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Regular",
            fontSize: 20,
            figmaLetterSpacing: -0.45,
            figmaLineHeight: 25
        )
    }

    /// Body1
    func body1() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Medium",
            fontSize: 18,
            figmaLetterSpacing: -0.2,
            figmaLineHeight: 23
        )
    }

    /// Body2-Medium
    func body2Medium() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Medium",
            fontSize: 16,
            figmaLetterSpacing: 0,
            figmaLineHeight: 21
        )
    }

    /// Body2-Regular
    func body2Regular() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Regular",
            fontSize: 16,
            figmaLetterSpacing: 0,
            figmaLineHeight: 21
        )
    }

    /// Label1-SemiBold
    func label1SemiBold() -> some View {
        applyTextStyle(
            fontName: "Pretendard-SemiBold",
            fontSize: 14,
            figmaLetterSpacing: 0,
            figmaLineHeight: 19
        )
    }

    /// Label1-Medium
    func label1Medium() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Medium",
            fontSize: 14,
            figmaLetterSpacing: 0,
            figmaLineHeight: 19
        )
    }

    /// Label1-Regular
    func label1Regular() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Regular",
            fontSize: 14,
            figmaLetterSpacing: 0,
            figmaLineHeight: 19
        )
    }

    /// Label2
    func label2() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Regular",
            fontSize: 13,
            figmaLetterSpacing: 0,
            figmaLineHeight: 17
        )
    }

    /// Label3-SemiBold
    func label3SemiBold() -> some View {
        applyTextStyle(
            fontName: "Pretendard-SemiBold",
            fontSize: 12,
            figmaLetterSpacing: 0.2,
            figmaLineHeight: 17
        )
    }

    /// Label3-Regular
    func label3Regular() -> some View {
        applyTextStyle(
            fontName: "Pretendard-Regular",
            fontSize: 12,
            figmaLetterSpacing: 0.2,
            figmaLineHeight: 17
        )
    }
}
