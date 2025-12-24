class StudyPlanResponse {
  final CourseCategory? genedCourses;
  final CourseCategory? majorCourses;
  final CourseCategory? freeElectiveCourses;
  final String? totalCourseCradits;
  final String? earnedTotalCradits;
  
  // สำหรับ filtered response
  final int? earnedCradits;
  final String? totalCradits;
  final List<FilteredCategory>? data;

  StudyPlanResponse({
    this.genedCourses,
    this.majorCourses,
    this.freeElectiveCourses,
    this.totalCourseCradits,
    this.earnedTotalCradits,
    this.earnedCradits,
    this.totalCradits,
    this.data,
  });

  factory StudyPlanResponse.fromJson(Map<String, dynamic> json) {
    // ตรวจสอบว่าเป็น response แบบปกติหรือ filtered
    if (json.containsKey('GenedCourses')) {
      return StudyPlanResponse(
        genedCourses: json['GenedCourses'] != null 
            ? CourseCategory.fromJson(json['GenedCourses']) 
            : null,
        majorCourses: json['MajorCourses'] != null
            ? CourseCategory.fromJson(json['MajorCourses'])
            : null,
        freeElectiveCourses: json['FreeElectiveCourses'] != null
            ? CourseCategory.fromJson(json['FreeElectiveCourses'])
            : null,
        totalCourseCradits: json['TotalCourseCradits']?.toString(),
        earnedTotalCradits: json['EarnedTotalCradits']?.toString(),
      );
    } else {
      // Filtered response
      return StudyPlanResponse(
        earnedCradits: json['EarnedCradits'],
        totalCradits: json['TotalCradits']?.toString(),
        data: (json['Data'] as List?)
            ?.map((item) => FilteredCategory.fromJson(item))
            .toList(),
      );
    }
  }
}

class CourseCategory {
  final String courseType;
  final String totalCradits;
  final String earnedCredits;
  final List<Course> data;

  CourseCategory({
    required this.courseType,
    required this.totalCradits,
    required this.earnedCredits,
    required this.data,
  });

  factory CourseCategory.fromJson(Map<String, dynamic> json) {
    return CourseCategory(
      courseType: json['course_type'] ?? '',
      totalCradits: json['total_cradits']?.toString() ?? '0',
      earnedCredits: json['earned_credits']?.toString() ?? '0',
      data: (json['data'] as List?)
          ?.map((item) => Course.fromJson(item))
          .toList() ?? [],
    );
  }
}

class Course {
  final String subjectId;
  final String subjectNameEn;
  final int credit;
  final bool status;

  Course({
    required this.subjectId,
    required this.subjectNameEn,
    required this.credit,
    required this.status,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      subjectId: json['subject_id'] ?? '',
      subjectNameEn: json['subject_name_en'] ?? '',
      credit: json['credit'] ?? 0,
      status: json['status'] ?? false,
    );
  }
}

class FilteredCategory {
  final String title;
  final List<Course> data;

  FilteredCategory({
    required this.title,
    required this.data,
  });

  factory FilteredCategory.fromJson(Map<String, dynamic> json) {
    return FilteredCategory(
      title: json['Tiltle'] ?? '',
      data: (json['Data'] as List?)
          ?.map((item) => Course.fromJson(item))
          .toList() ?? [],
    );
  }
}