import os
import json


# colors처럼 글로벌 네임 컬러와 시멘틱 내임 컬러가 모두 들어가 있는 파일이 필요하다 -> 이 시멘틱 네임 컬러랑, 글로벌 컬러가 다른 파일에 있어도 처리할 수 있도록 만들어야 한다
# design tokens 플러그인용
# design tokens의 Settings의 NameSetting이 디폴트여야함 (스네이크, 카멜케이스면 안됨)
# 다른 경로에 둔 다음 엑스코드 프로젝트에 직접 추가할것 (경로 문제  떄문에)
# 컬러(시멘틱 네임 컬러, 글로벌 네임 컬러)가 들어가 있는 컬렉션명을 꼭 color_location에 모두 넣을것
# json 파일위치 파일생성 위치를 모두 지정할 것


# JSON file 불러오기
def load_json_file(file_path):
    with open(file_path, 'r') as file:
        return json.load(file)

def hex_to_rgba(hex_value):
    hex_value = hex_value.lstrip('#')
    
    # HEX 값의 길이가 6자리 또는 8자리일 경우만 처리
    if len(hex_value) not in (6, 8):
        raise ValueError("Invalid HEX value. HEX code must be 6 or 8 characters long.")
    
    # 6자리인 경우에는 alpha 값을 기본적으로 1.0으로 설정
    red = int(hex_value[0:2], 16)
    green = int(hex_value[2:4], 16)
    blue = int(hex_value[4:6], 16)
    alpha = int(hex_value[6:8], 16) if len(hex_value) == 8 else 255  # 255는 1.0과 동일
    
    return {
        "red": round(red / 255.0, 8),
        "green": round(green / 255.0, 8),
        "blue": round(blue / 255.0, 8),
        "alpha": round(alpha / 255.0, 8)
    }


# 색상 데이터를 추출하고, RGB 값으로 변환된 색상 딕셔너리와 나머지 요소 리스트를 반환하는 함수
def extract_and_convert_color_data(json_file_path="design-tokens.tokens.json", color_locations=None, categories=None):
    # JSON 파일 로드
    if isinstance(json_file_path, str):
        data = load_json_file(json_file_path)
    else:
        data = json_file_path

    # color_locations가 리스트일 경우 처리
    if not isinstance(color_locations, list):
        color_locations = [color_locations]

    rgb_colors = {}
    remaining_items = []
    
    # 각 컬러 폴더를 순회하며 데이터를 처리
    for color_location in color_locations:
        color_raw_data = data.get(color_location, {})
        
        # 색상 데이터 추출
        extract_colors_from_folder(color_raw_data, rgb_colors, remaining_items, categories)
    
    return rgb_colors, remaining_items


# 특정 폴더 내 색상 데이터를 처리하는 재귀 함수
def extract_colors_from_folder(color_raw_data, rgb_colors, remaining_items, categories=None):
    if categories is None:
        categories = []

    for key, value in color_raw_data.items():
        current_path = categories + [key]  # 경로 추적
        if isinstance(value, dict) and 'value' not in value:
            # 'value'가 없으면 재귀적으로 더 깊이 탐색
            extract_colors_from_folder(value, rgb_colors, remaining_items, current_path)
        else:
            # 'value'가 있는 경우 HEX 값을 RGB로 변환하거나 나머지 요소로 처리
            hex_value = value.get("value")
            if hex_value and hex_value.startswith('#'):
                # HEX 형식의 값만 변환
                rgba_value = hex_to_rgba(hex_value)  # HEX to RGBA 변환
                rgb_value = (rgba_value["red"], rgba_value["green"], rgba_value["blue"], rgba_value["alpha"])
                # 경로의 마지막 키(색상 이름)만 사용
                color_name = key
                rgb_colors[color_name] = rgb_value
            else:
                # 나머지 요소는 리스트에 추가
                remaining_items.append({
                    "path": current_path,
                    "item_name": key,
                    "value": value.get("value"),
                    "type": value.get("type")
                })


# 경로와 파일 이름에 따른 폴더 생성 함수 및 Contents.json 파일 작성
def create_folders_and_generate_json(rgb_colors, remaining_items, base_path):
    for item in remaining_items:
        path_list = item['path'][:-1]  # 마지막 경로 제외
        folder_path = os.path.join(base_path, *path_list)  # 기본 경로와 결합
        final_folder_name = item['path'][-1] + '.colorset'  # 마지막 항목에 .colorset 붙이기
        final_folder_path = os.path.join(folder_path, final_folder_name)
        # 폴더가 없으면 생성
        if not os.path.exists(final_folder_path):
            os.makedirs(final_folder_path)

        # 컬러 값이 {colors.default.foundation.black.black-6} 같은 참조일 경우 처리
        color_reference = item['value']
        if color_reference and color_reference.startswith("{colors"):
            # 참조를 추출하여 RGB 색상이 존재하는지 확인
            color_key = color_reference.strip("{}").split(".")[-1]  # 'black-6' 추출
            if color_key in rgb_colors:
                rgb = rgb_colors[color_key]

                # Contents.json 파일 생성
                color_json = {
                    "colors": [
                        {
                            "color": {
                                "color-space": "srgb",
                                "components": {
                                    "red": f"{rgb[0]:.8f}",
                                    "green": f"{rgb[1]:.8f}",
                                    "blue": f"{rgb[2]:.8f}",
                                    "alpha": f"{rgb[3]:.8f}"
                                }
                            },
                            "idiom": "universal"
                        }
                    ],
                    "info": {
                        "author": "xcode",
                        "version": 1
                    }
                }

                # Contents.json 파일을 해당 폴더에 작성
                contents_json_path = os.path.join(final_folder_path, "Contents.json")
                with open(contents_json_path, 'w') as json_file:
                    json.dump(color_json, json_file, indent=4)
            else:
                print(f"Color key {color_key} not found in rgb_colors")


def design_tokens_plugin_main(file_path="design-tokens.tokens.json", color_location=["colors"], base_file_path="/Users/sunyoung/Downloads/6_MacC/2024-MacC-A1-2manythinking/TMT/TMT/Assets.xcassets"):
    color_lst, var_items = extract_and_convert_color_data(file_path, color_location)
    create_folders_and_generate_json(color_lst, var_items, base_file_path)

# 실행 예시
file_path = "design-tokens.tokens.json"
color_location = ["colors"]
base_file_path = "/Users/sunyoung/Downloads/6_MacC/2024-MacC-A1-2manythinking/TMT/TMT/Assets.xcassets"

design_tokens_plugin_main(file_path, color_location, base_file_path)
