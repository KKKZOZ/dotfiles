#!/usr/bin/env python3

def calculate_model_parameters(input_price_per_million, output_price_per_million):
    """
    计算大模型的模型倍率和补全倍率。

    Args:
      input_price_per_million: 每 1M Token 输入的价格（美元）。
      output_price_per_million: 每 1M Token 输出的价格（美元）。

    Returns:
      一个字典，包含模型倍率和补全倍率。
      如果输入价格为0，返回错误信息。
    """

    if input_price_per_million <= 0:
        return {"error": "输入价格必须大于 0"}

    # 基础价格中，500,000个提示token的价格被定义为$1
    base_price_for_500k_input = 1

    # 计算 500,000 tokens 的输入和输出价格
    input_price_for_500k = (input_price_per_million / 1000000) * 500000
    output_price_for_500k = (output_price_per_million / 1000000) * 500000

    # 计算补全倍率
    completion_multiplier = output_price_for_500k / input_price_for_500k

    # 计算模型倍率
    model_multiplier = input_price_for_500k / base_price_for_500k_input

    return {
        "model_multiplier": model_multiplier,
        "completion_multiplier": completion_multiplier,
    }

if __name__ == "__main__":
    try:
        input_price = float(input("请输入每 1M Token 输入的价格（美元）: "))
        output_price = float(input("请输入每 1M Token 输出的价格（美元）: "))

        parameters = calculate_model_parameters(input_price, output_price)

        if "error" in parameters:
            print(parameters["error"])
        else:
            print(f"模型倍率: {parameters['model_multiplier']}")
            print(f"补全倍率: {parameters['completion_multiplier']}")

    except ValueError:
        print("输入错误：请输入有效的数字。")

