import 'dart:io';

void main() {
  // -------------------------------------------
  // 1. App Setup & Constants (Feature 1)
  // -------------------------------------------

  //app name and available subject
  const String appTitle = 'Student Grader v1.0';
  final Set<String> availableSubjects = {
    'Math',
    'Physics',
    'Chemistry',
    'Biology',
  };
  //mutable state
  var studentList = <Map<String, dynamic>>[];
  var isRunning = true;
  var userInput = '';

  // -------------------------------------------
  // 2. The Menu Loop (Feature 2)
  // -------------------------------------------
  do {
    //menu display
    print("===== $appTitle =====");
    print('''
1. Add Student
2. Record Score
3. Add Bonus Points
4. Add Comment
5. View All Students
6. View Report Card
7. Class Summary
8. Exit
''');
    stdout.write("Choose an option: ");
    //get user input for menu selection
    userInput =
        stdin.readLineSync()?.trim() ?? ""; // trim to remove extra spaces
    switch (userInput) {
      // -------------------------------------------
      // 3. Add Student (Feature 3)
      // -------------------------------------------
      case '1':
        //get student name input
        stdout.write("Enter student name: ");
        var nameInput = stdin.readLineSync()?.trim() ?? '';
        if (nameInput.isNotEmpty) {
          var newStudent = {
            "name": nameInput,
            'score': <int>[],
            'subjects': {...availableSubjects}, //used spread operator
            'bonus': null,
            'comment': null,
          };
          studentList.add(newStudent);
          print("\n[✔] Student '$nameInput' added successfully.");
        }
        break;
      // -------------------------------------------
      // 4. Record Score (Feature 4)
      // -------------------------------------------
      case '2':
        //check if student list is empty
        if (studentList.isEmpty) {
          print("\n[!] No students available. Please add students first.");
          break;
        }
        //student list display
        print("\n--- RECORD SCORE ---");
        for (var i = 0; i < studentList.length; i++) {
          print("${i + 1}. ${studentList[i]['name']}");
        }
        //student selection
        stdout.write("\nSelect Student Serial Number: ");
        var stuIdx =
            (int.tryParse(stdin.readLineSync()?.trim() ?? "") ?? 0) - 1;
        if (stuIdx < 0 || stuIdx >= studentList.length) {
          print("\n[!] Invalid student selection.");
          break;
        }
        var selectedStudent = studentList[stuIdx];

        //subject list and score list reference
        var subs = (selectedStudent['subjects'] as Set<String>).toList();
        var scoreList = selectedStudent['score'] as List<int>;

        //subject display
        print("\nAvailable Subjects for ${selectedStudent['name']}:");
        for (var i = 0; i < subs.length; i++) {
          print("${i + 1}. ${subs[i]}");
        }
        //subject selection
        stdout.write("Select Subject Serial Number: ");
        var subjectIdx =
            (int.tryParse(stdin.readLineSync()?.trim() ?? "") ?? 0) - 1;

        if (subjectIdx < 0 || subjectIdx >= subs.length) {
          print("\n[!]Error: Invalid subject selection.");
          break;
        }

        var subject = subs[subjectIdx];

        //score input
        var score = -1;
        while (score < 0 || score > 100) {
          stdout.write("Enter score for [$subject] (0-100): ");
          var input = stdin.readLineSync()?.trim() ?? "";
          score = int.tryParse(input) ?? -1;

          if (score < 0 || score > 100) {
            print(
              "\n[!] Invalid score. Please enter a number between 0 and 100.",
            );
          }
        }
        //record score
        scoreList.add(score);
        print(
          "\n[✔] Score of $score recorded for ${selectedStudent['name']} in $subject.",
        );
        break;
      // -------------------------------------------
      // 5. Add Bonus Points (Feature 5)
      // -------------------------------------------
      case '3':
        //check if student list is empty
        if (studentList.isEmpty) {
          print("\n[!] No students available. Please add students first.");
          break;
        }
        //student list display
        print("\n--- ADD BONUS POINTS ---");
        for (var i = 0; i < studentList.length; i++) {
          print("${i + 1}. ${studentList[i]['name']}");
        }
        //student selection
        stdout.write("\nSelect Student Serial Number: ");
        var stuIdx =
            (int.tryParse(stdin.readLineSync()?.trim() ?? "") ?? 0) - 1;
        if (stuIdx < 0 || stuIdx >= studentList.length) {
          print("\n[!]Error: Invalid student selection.");
          break;
        }
        var selectedStudent = studentList[stuIdx];
        //bonus validation check
        if (selectedStudent['bonus'] != null) {
          print(
            "\n[!]Error: ${selectedStudent['name']} already has a bonus of ${selectedStudent['bonus']} points.",
          );
          break;
        } else {
          stdout.write(
            "Enter bonus points for ${selectedStudent['name']} (0-10): ",
          );
          var bonusInput =
              int.tryParse(stdin.readLineSync()?.trim() ?? "") ?? 0;
          if (bonusInput < 1 || bonusInput > 10) {
            print("\n[!] Error: Bonus must be between 1 and 10.");
            break;
          }
          selectedStudent['bonus'] ??= bonusInput; //used ??= operator
          print(
            "\n[✔] Success: Bonus of $bonusInput points added for ${selectedStudent['name']}.",
          );
        }
        break;
      // -------------------------------------------
      // 6. Add Comment (Feature 6)
      // -------------------------------------------
      case '4':
        //check if student list is empty
        if (studentList.isEmpty) {
          print("\n[!] No students available. Please add students first.");
          break;
        }
        print("\n--- ADD COMMENT ---");
        for (var i = 0; i < studentList.length; i++) {
          print("${i + 1}. ${studentList[i]['name']}");
        }
        stdout.write("\nSelect Student Serial Number: ");
        var stuIdx =
            (int.tryParse(stdin.readLineSync()?.trim() ?? "") ?? 0) - 1;
        if (stuIdx < 0 || stuIdx >= studentList.length) {
          print("\n[!]Error: Invalid student selection.");
          break;
        }
        var selectedStudent = studentList[stuIdx];
        stdout.write("Enter comment for ${selectedStudent['name']}: ");
        var commentInput =
            stdin.readLineSync()?.trim().toUpperCase() ??
            'NO COMMENT  PROVIDED';
        if (commentInput.isNotEmpty) {
          selectedStudent['comment'] = commentInput;
          print(
            "\n[✔] Comment added for ${selectedStudent['name']}: $commentInput",
          );
        } else {
          print("\n[!] Error: Comment cannot be empty.");
        }
        break;
      // -------------------------------------------
      // 7. View All Students (Feature 7)
      // -------------------------------------------
      case '5':
        //check if student list is empty
        if (studentList.isEmpty) {
          print("\n[!] No students available. Please add students first.");
          break;
        }
        //display all students with details
        print("\n--- ALL STUDENTS LIST ---");
        for (var student in studentList) {
          //create list with string interpolation and collection if
          var details = [
            "Name: ${student['name']}",
            "Scores: ${student['score']}",
            if (student['bonus'] != null)
              "Bonus: ${student['bonus']} points", //used collection if
          ];
          print(details.join(" | "));
          print("Comment: ${student['comment'] ?? 'No comment'}");
          print("-" * 40);
        }
        break;

      // -------------------------------------------
      // 8. View Report Card (Feature 8)
      // -------------------------------------------
      case '6':
        //check if student list is empty
        if (studentList.isEmpty) {
          print("\n[!] No students available. Please add students first.");
          break;
        }
        //student list display
        print("\n--- VIEW REPORT CARD ---");
        for (var i = 0; i < studentList.length; i++) {
          print("${i + 1}. ${studentList[i]['name']}");
        }
        //student selection
        stdout.write("\nSelect Student Serial Number: ");
        var stuIdx =
            (int.tryParse(stdin.readLineSync()?.trim() ?? "") ?? 0) - 1;

        if (stuIdx < 0 || stuIdx >= studentList.length) {
          print("\n[!]Error: Invalid student selection.");
          break;
        }

        var selectedStudent = studentList[stuIdx];
        var scores = selectedStudent['score'] as List<int>;
        var bonus = selectedStudent['bonus'] as int? ?? 0;

        //calculation part
        double avrgScore = 0;
        if (scores.isNotEmpty) {
          //calculate average score
          int total = 0;
          for (var score in scores) {
            total += score;
          }
          avrgScore = total / scores.length;
        }

        //adding bonus to average score
        double finalScore = (avrgScore + (selectedStudent['bonus'] ?? 0)).clamp(
          0,
          100,
        ); //used clamp to ensure final score is between 0 and 100

        //grade calculation using if else ladder
        String grade = finalScore >= 90
            ? "A"
            : finalScore >= 80
            ? "B"
            : finalScore >= 70
            ? "C"
            : finalScore >= 60
            ? "D"
            : "F";

        // giving comment based on grade using switch case
        String feedback = switch (grade) {
          "A" => "Outstanding performance!",
          "B" => "Good work, keep it up!",
          "C" => "Satisfactory. Room to improve.",
          "D" => "Needs improvement.",
          "F" => "Failing. Please seek help.",
          _ => "Unknown grade.",
        };

        //report card display
        print('''
╔══════════════════════════════════════╗
║             REPORT CARD              ║
╠══════════════════════════════════════╣
║  Name:    ${selectedStudent['name'].padRight(31)}║
║  Scores:  ${scores.join(", ").padRight(31)}║
║  Bonus:   ${bonus.toString().padRight(31)}║
║  Average: ${avrgScore.toStringAsFixed(2).padRight(31)}║
║  Grade:   ${grade.padRight(31)}║
║  Comment: ${feedback.padRight(31)}║
╚══════════════════════════════════════╝''');
        break;
    }
  } while (isRunning);
}
