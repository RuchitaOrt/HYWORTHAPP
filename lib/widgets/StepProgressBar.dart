
import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isEven) {
              int stepIndex = index ~/ 2;
              bool isActive = stepIndex == currentStep;
              bool isCompleted = stepIndex < currentStep;

              return Container(
                width: 4,
                height: 0,
               
              );
            } else {
              return Expanded(
                child: Container(
                  height: 5,
                   decoration: BoxDecoration(
                            color: index ~/ 2 < currentStep
                      ? CommonColors.blue
                      : CommonColors.lightgrey,
                            // border: Border.all(color: CattleColors.grey61, width: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                 
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: steps
              .map((title) => Expanded(
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ))
              .toList(),
        )
      ],
    );
  }
}
