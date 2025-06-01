import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sfs/models/course.dart';

class CourseRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Management Courses

  // Upload Mata Kuliah
  // Future<void> uploadCourses(List<Course> courses) async {
  //   final CollectionReference coursesCollection = _db.collection('courses');
  //   WriteBatch batch = _db.batch();

  //   for (var course in courses) {
  //     DocumentReference docRef = coursesCollection.doc(course.code);
  //     batch.set(docRef, course.toMap());
  //   }

  //   await batch.commit();
  //   print('Courses uploaded successfully!');
  // }

  // Upload Mata Kuliah Relevan
  // Future<void> uploadRelevantCourses(List<RelevantCourse> relevantCourses) async {
  //   final CollectionReference relevantCoursesCollection = _db.collection('relevant_courses');
  //   WriteBatch batch = _db.batch();

  //   for (var relevantCourse in relevantCourses) {
  //     DocumentReference docRef = relevantCoursesCollection.doc();
  //     batch.set(docRef, relevantCourse.toMap());
  //   }

  //   await batch.commit();
  //   print('Relevant courses uploaded successfully!');
  // }

  // Get Mata Kuliah
  Future<List<Course>> getCoursesFromFirestore() async {
    QuerySnapshot snapshot = await _db.collection('courses').get();
    return snapshot.docs.map((doc) => Course.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<RelevantCourse>> getRelevantCoursesForMainCourse(String mainCourseCode) async {
    QuerySnapshot snapshot = await _db
        .collection('relevant_courses')
        .where('mainCourseCode', isEqualTo: mainCourseCode)
        .get();
    return snapshot.docs.map((doc) => RelevantCourse.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}