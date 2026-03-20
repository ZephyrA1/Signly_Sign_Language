/// Maps lesson IDs to the expected sign name for camera detection.
/// Used by lesson_camera_screen and camera_practice_screen to verify
/// whether the user's performed sign matches the lesson target.
class LessonSignMap {
  static const Map<String, String> expectedSigns = {
    'u1l1': 'Hello',
    'u1l2': 'Hello',
    'u1l3': 'Thank You',
    'u1l4': 'Please',
    'u1l5': 'Hello',
    'u2l1': 'Please',
    'u2l2': 'Yes',
    'u2l3': 'Thank You',
    'u2l4': 'Sorry',
    'u3l1': 'Teacher',
    'u3l2': 'Teacher',
    'u3l3': 'Please',
    'u3l4': 'Thank You',
    'u4l1': 'Mother',
    'u4l2': 'Father',
    'u4l3': 'Mother',
    'u4l4': 'Friend',
    'u4l5': 'Mother',
  };

  /// Get the expected sign for a lesson, or null if not mapped.
  static String? getExpectedSign(String lessonId) => expectedSigns[lessonId];
}

class SignLanguageVariant {
  final String code;
  final String name;
  final String flag;

  const SignLanguageVariant({
    required this.code,
    required this.name,
    required this.flag,
  });

  static const List<SignLanguageVariant> all = [
    SignLanguageVariant(code: 'ASL', name: 'American Sign Language', flag: 'assets/usa.png'),
    SignLanguageVariant(code: 'BSL', name: 'British Sign Language', flag: 'assets/british.png'),
    SignLanguageVariant(code: 'LSF', name: 'French Sign Language', flag: 'assets/france.png'),
    SignLanguageVariant(code: 'CSL', name: 'Chinese Sign Language', flag: 'assets/china.png'),
    SignLanguageVariant(code: 'RSL', name: 'Russian Sign Language', flag: 'assets/russia.png'),
  ];
}

class LessonUnit {
  final String id;
  final String title;
  final String subtitle;
  final int lessonCount;
  final double progress;
  final String skillFocus;
  final List<UnitLesson> lessons;

  const LessonUnit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.lessonCount,
    required this.progress,
    required this.skillFocus,
    required this.lessons,
  });

  static const List<LessonUnit> sampleUnits = [
    LessonUnit(
      id: 'u1',
      title: 'Greetings and Introductions',
      subtitle: 'Learn essential greeting signs',
      lessonCount: 5,
      progress: 0.0,
      skillFocus: 'Basic Communication',
      lessons: [
        UnitLesson(id: 'u1l1', title: 'Hello and Goodbye', duration: '8 min'),
        UnitLesson(id: 'u1l2', title: 'My Name Is...', duration: '10 min'),
        UnitLesson(id: 'u1l3', title: 'Nice to Meet You', duration: '8 min'),
        UnitLesson(id: 'u1l4', title: 'How Are You?', duration: '10 min'),
        UnitLesson(id: 'u1l5', title: 'Introducing Others', duration: '12 min'),
      ],
    ),
    LessonUnit(
      id: 'u2',
      title: 'Everyday Expressions',
      subtitle: 'Common phrases for daily use',
      lessonCount: 4,
      progress: 0.0,
      skillFocus: 'Daily Communication',
      lessons: [
        UnitLesson(id: 'u2l1', title: 'Please and Thank You', duration: '8 min'),
        UnitLesson(id: 'u2l2', title: 'Yes, No, and Maybe', duration: '7 min'),
        UnitLesson(id: 'u2l3', title: 'Asking for Help', duration: '10 min'),
        UnitLesson(id: 'u2l4', title: 'Expressing Feelings', duration: '12 min'),
      ],
    ),
    LessonUnit(
      id: 'u3',
      title: 'School and Classroom',
      subtitle: 'Signs for educational settings',
      lessonCount: 4,
      progress: 0.0,
      skillFocus: 'Academic Context',
      lessons: [
        UnitLesson(id: 'u3l1', title: 'Classroom Objects', duration: '10 min'),
        UnitLesson(id: 'u3l2', title: 'Teacher and Student', duration: '8 min'),
        UnitLesson(id: 'u3l3', title: 'Asking Questions', duration: '10 min'),
        UnitLesson(id: 'u3l4', title: 'School Activities', duration: '12 min'),
      ],
    ),
    LessonUnit(
      id: 'u4',
      title: 'Family and Relationships',
      subtitle: 'Signs for family members and relationships',
      lessonCount: 5,
      progress: 0.0,
      skillFocus: 'Personal Connections',
      lessons: [
        UnitLesson(id: 'u4l1', title: 'Family Members', duration: '10 min'),
        UnitLesson(id: 'u4l2', title: 'Describing People', duration: '12 min'),
        UnitLesson(id: 'u4l3', title: 'Ages and Birthdays', duration: '8 min'),
        UnitLesson(id: 'u4l4', title: 'Relationships', duration: '10 min'),
        UnitLesson(id: 'u4l5', title: 'Family Activities', duration: '12 min'),
      ],
    ),
  ];
}

class UnitLesson {
  final String id;
  final String title;
  final String duration;

  const UnitLesson({
    required this.id,
    required this.title,
    required this.duration,
  });
}

class VocabularyItem {
  final String sign;
  final String meaning;
  final String category;
  final String handshape;
  final String movement;
  final String placement;
  final String commonMistake;
  final String exampleContext;

  const VocabularyItem({
    required this.sign,
    required this.meaning,
    required this.category,
    required this.handshape,
    required this.movement,
    required this.placement,
    required this.commonMistake,
    required this.exampleContext,
  });

  static const List<VocabularyItem> sampleItems = [
    VocabularyItem(
      sign: 'Hello',
      meaning: 'A greeting used when meeting someone',
      category: 'Greetings',
      handshape: 'Open hand, fingers together',
      movement: 'Hand moves away from forehead in a salute-like motion',
      placement: 'Starts near the forehead',
      commonMistake: 'Moving the hand too far from the face',
      exampleContext: 'Use when greeting a friend or meeting someone new',
    ),
    VocabularyItem(
      sign: 'Thank You',
      meaning: 'Expression of gratitude',
      category: 'Everyday',
      handshape: 'Flat hand, palm facing you',
      movement: 'Hand moves forward from chin',
      placement: 'Starts at the chin',
      commonMistake: 'Starting too low - should begin at chin level',
      exampleContext: 'After receiving help or a gift',
    ),
    VocabularyItem(
      sign: 'Please',
      meaning: 'Polite request word',
      category: 'Everyday',
      handshape: 'Flat hand on chest',
      movement: 'Circular motion on the chest',
      placement: 'Center of chest',
      commonMistake: 'Making the circle too small',
      exampleContext: 'When asking someone for something politely',
    ),
    VocabularyItem(
      sign: 'Sorry',
      meaning: 'Expression of apology',
      category: 'Everyday',
      handshape: 'Fist with thumb extended (A handshape)',
      movement: 'Circular motion on chest',
      placement: 'Center of chest',
      commonMistake: 'Confusing with PLEASE - Sorry uses a fist, Please uses flat hand',
      exampleContext: 'When apologizing for a mistake',
    ),
    VocabularyItem(
      sign: 'Yes',
      meaning: 'Affirmative response',
      category: 'Everyday',
      handshape: 'S handshape (fist)',
      movement: 'Nod the fist up and down',
      placement: 'In front of the body',
      commonMistake: 'Moving the whole arm instead of just the wrist',
      exampleContext: 'Answering a yes/no question',
    ),
    VocabularyItem(
      sign: 'No',
      meaning: 'Negative response',
      category: 'Everyday',
      handshape: 'Index and middle finger extended',
      movement: 'Snap fingers together with thumb',
      placement: 'In front of the body',
      commonMistake: 'Using only the index finger',
      exampleContext: 'Declining an offer or answering negatively',
    ),
    VocabularyItem(
      sign: 'Teacher',
      meaning: 'A person who instructs others',
      category: 'School',
      handshape: 'Both hands in flat O shape near temples',
      movement: 'Move hands outward, then add PERSON marker',
      placement: 'Near the temples',
      commonMistake: 'Forgetting the PERSON marker at the end',
      exampleContext: 'Referring to your instructor in class',
    ),
    VocabularyItem(
      sign: 'Mother',
      meaning: 'Female parent',
      category: 'Family',
      handshape: 'Open hand, thumb touching chin',
      movement: 'Thumb taps chin',
      placement: 'At the chin',
      commonMistake: 'Touching the forehead instead of chin (that means Father)',
      exampleContext: 'Talking about your family',
    ),
    VocabularyItem(
      sign: 'Father',
      meaning: 'Male parent',
      category: 'Family',
      handshape: 'Open hand, thumb touching forehead',
      movement: 'Thumb taps forehead',
      placement: 'At the forehead',
      commonMistake: 'Touching the chin instead of forehead (that means Mother)',
      exampleContext: 'Talking about your family',
    ),
    VocabularyItem(
      sign: 'Friend',
      meaning: 'A person you have a bond with',
      category: 'Relationships',
      handshape: 'Index fingers hooked together',
      movement: 'Hook and switch positions',
      placement: 'In front of the body',
      commonMistake: 'Not switching the hook direction',
      exampleContext: 'Introducing someone as your friend',
    ),
  ];

  static List<String> get categories =>
      sampleItems.map((e) => e.category).toSet().toList();
}

/// Maps lesson IDs to their video asset paths.
/// Each lesson can have multiple videos: correct demonstrations,
/// incorrect demonstrations (for error analysis), and additional signs.
class LessonVideoMap {
  /// Returns the primary "correct" demonstration video for a lesson.
  static String? correctVideo(String lessonId) {
    return _correctVideos[lessonId];
  }

  /// Returns the "incorrect" demonstration video for error analysis.
  static String? incorrectVideo(String lessonId) {
    return _incorrectVideos[lessonId];
  }

  /// Returns an extra / secondary video for a lesson (e.g. second sign).
  static String? extraVideo(String lessonId) {
    return _extraVideos[lessonId];
  }

  /// Returns true if any video exists for this lesson.
  static bool hasVideo(String lessonId) {
    return _correctVideos.containsKey(lessonId);
  }

  // ── Unit 1 Lesson 1: Hello and Goodbye ──
  static const Map<String, String> _correctVideos = {
    'u1l1': 'assets/videos/u1l1_hello_correct.mp4',
    // Future lessons – add entries as videos are generated:
    // 'u1l2': 'assets/videos/u1l2_my_correct.mp4',
    // 'u1l3': 'assets/videos/u1l3_nice_correct.mp4',
    // 'u1l4': 'assets/videos/u1l4_how_correct.mp4',
    // 'u1l5': 'assets/videos/u1l5_this_correct.mp4',
    // 'u2l1': 'assets/videos/u2l1_please_correct.mp4',
  };

  static const Map<String, String> _incorrectVideos = {
    'u1l1': 'assets/videos/u1l1_hello_incorrect.mp4',
    // 'u1l2': 'assets/videos/u1l2_name_incorrect.mp4',
  };

  static const Map<String, String> _extraVideos = {
    'u1l1': 'assets/videos/u1l1_goodbye.mp4',
    // 'u1l2': 'assets/videos/u1l2_name_correct.mp4',
  };
}

class ScenarioData {
  final String topic;
  final String scenario;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const ScenarioData({
    required this.topic,
    required this.scenario,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  static const List<ScenarioData> sampleScenarios = [
    ScenarioData(
      topic: 'Greetings',
      scenario: 'You are meeting your teacher for the first time at school.',
      options: ['Wave casually', 'Sign HELLO formally', 'Sign HI + NICE MEET YOU', 'Nod your head'],
      correctIndex: 2,
      explanation: 'In a formal first meeting, signing HI followed by NICE MEET YOU shows proper etiquette and respect.',
    ),
    ScenarioData(
      topic: 'School',
      scenario: 'You need to ask your Deaf classmate to borrow a pencil.',
      options: ['Point at pencil', 'Sign PLEASE + BORROW + PENCIL', 'Wave to get attention then point', 'Sign GIVE ME'],
      correctIndex: 1,
      explanation: 'Using PLEASE with your request is polite and shows proper sign language communication skills.',
    ),
    ScenarioData(
      topic: 'Family',
      scenario: 'You want to introduce your mother to a Deaf friend.',
      options: ['Point at her', 'Sign THIS MY MOTHER', 'Sign MOTHER + fingerspell name', 'Sign WOMAN HERE'],
      correctIndex: 2,
      explanation: 'Signing MOTHER and then fingerspelling her name is the proper way to make an introduction.',
    ),
    ScenarioData(
      topic: 'Daily Life',
      scenario: 'A Deaf person at the store asks you a question and you don\'t understand.',
      options: ['Walk away', 'Sign SORRY + AGAIN PLEASE', 'Shake your head', 'Sign I DON\'T KNOW'],
      correctIndex: 1,
      explanation: 'Signing SORRY and asking them to repeat shows respect and willingness to communicate.',
    ),
    ScenarioData(
      topic: 'Work',
      scenario: 'Your Deaf colleague did a great job on a project presentation.',
      options: ['Sign GOOD JOB', 'Clap your hands', 'Wave both hands (Deaf applause)', 'Give thumbs up'],
      correctIndex: 2,
      explanation: 'In Deaf culture, waving both hands in the air is the equivalent of applause and is the culturally appropriate response.',
    ),
  ];
}

class CultureNote {
  final String title;
  final String description;
  final String icon;

  const CultureNote({
    required this.title,
    required this.description,
    required this.icon,
  });

  static const List<CultureNote> sampleNotes = [
    CultureNote(
      title: 'Importance of Facial Expression',
      description: 'In sign language, facial expressions are grammatical markers, not just emotional cues. They can change the meaning of a sign entirely. For example, raised eyebrows indicate a yes/no question.',
      icon: 'face',
    ),
    CultureNote(
      title: 'Getting Attention',
      description: 'To get a Deaf person\'s attention, you can wave in their line of sight, tap their shoulder gently, or flash the lights. Never throw objects or grab someone forcefully.',
      icon: 'attention',
    ),
    CultureNote(
      title: 'Respectful Communication',
      description: 'Maintain eye contact when signing or watching someone sign. Looking away is considered rude, similar to plugging your ears when someone is speaking.',
      icon: 'respect',
    ),
    CultureNote(
      title: 'Deaf Culture Identity',
      description: 'Many Deaf people view deafness as a cultural identity, not a disability. The capital D in "Deaf" refers to the cultural community, while lowercase "deaf" refers to the audiological condition.',
      icon: 'identity',
    ),
    CultureNote(
      title: 'Name Signs',
      description: 'In Deaf culture, name signs are given by Deaf community members, not chosen by yourself. Getting a name sign is a sign of acceptance into the community.',
      icon: 'name',
    ),
  ];
}
