class SignLanguageVariant {
  final String code;
  final String name;
  final String flag;

  const SignLanguageVariant({required this.code, required this.name, required this.flag});

  static const List<SignLanguageVariant> all = [
    SignLanguageVariant(code: 'ASL', name: 'American Sign Language', flag: 'assets/usa.png'),
    SignLanguageVariant(code: 'BSL', name: 'British Sign Language', flag: 'assets/british.png'),
    SignLanguageVariant(code: 'LSF', name: 'French Sign Language', flag: 'assets/france.png'),
    SignLanguageVariant(code: 'CSL', name: 'Chinese Sign Language', flag: 'assets/china.png'),
    SignLanguageVariant(code: 'RSL', name: 'Russian Sign Language', flag: 'assets/russia.png'),
  ];
}

// ── Lesson structure ────────────────────────────────────────────────────────

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

  static UnitLesson? nextLesson(String lessonId) {
    for (int u = 0; u < sampleUnits.length; u++) {
      final unit = sampleUnits[u];
      for (int l = 0; l < unit.lessons.length; l++) {
        if (unit.lessons[l].id == lessonId) {
          if (l + 1 < unit.lessons.length) return unit.lessons[l + 1];
          if (u + 1 < sampleUnits.length) return sampleUnits[u + 1].lessons[0];
          return null;
        }
      }
    }
    return null;
  }

  static UnitLesson? findLesson(String lessonId) {
    for (final unit in sampleUnits) {
      for (final lesson in unit.lessons) {
        if (lesson.id == lessonId) return lesson;
      }
    }
    return null;
  }

  static String? unitTitleFor(String lessonId) {
    for (final unit in sampleUnits) {
      for (final lesson in unit.lessons) {
        if (lesson.id == lessonId) return unit.title;
      }
    }
    return null;
  }

  static const List<LessonUnit> sampleUnits = [
    LessonUnit(
      id: 'u1', title: 'Greetings and Introductions',
      subtitle: 'Learn essential greeting signs', lessonCount: 5,
      progress: 0.0, skillFocus: 'Basic Communication',
      lessons: [
        UnitLesson(id: 'u1l1', title: 'Hello and Goodbye', duration: '8 min', signs: ['Hello', 'Goodbye']),
        UnitLesson(id: 'u1l2', title: 'My Name Is...', duration: '10 min', signs: ['Name', 'Hello']),
        UnitLesson(id: 'u1l3', title: 'Nice to Meet You', duration: '8 min', signs: ['Nice', 'Thank You']),
        UnitLesson(id: 'u1l4', title: 'Are You Fine?', duration: '10 min', signs: ['Please', 'Fine']),
        UnitLesson(id: 'u1l5', title: 'Introducing Others', duration: '12 min', signs: ['Friend', 'Hello']),
      ],
    ),
    LessonUnit(
      id: 'u2', title: 'Everyday Expressions',
      subtitle: 'Common phrases for daily use', lessonCount: 4,
      progress: 0.0, skillFocus: 'Daily Communication',
      lessons: [
        UnitLesson(id: 'u2l1', title: 'Please and Thank You', duration: '8 min', signs: ['Please', 'Thank You']),
        UnitLesson(id: 'u2l2', title: 'Yes, No, and Maybe', duration: '7 min', signs: ['Yes', 'No', 'Maybe']),
        UnitLesson(id: 'u2l3', title: 'Asking for Help', duration: '10 min', signs: ['Help', 'Please', 'Thank You']),
        UnitLesson(id: 'u2l4', title: 'Expressing Feelings', duration: '12 min', signs: ['Sorry', 'Happy', 'Sad']),
      ],
    ),
    LessonUnit(
      id: 'u3', title: 'School and Classroom',
      subtitle: 'Signs for educational settings', lessonCount: 4,
      progress: 0.0, skillFocus: 'Academic Context',
      lessons: [
        UnitLesson(id: 'u3l1', title: 'Classroom Objects', duration: '10 min', signs: ['Book', 'Pencil', 'Paper']),
        UnitLesson(id: 'u3l2', title: 'Teacher and Student', duration: '8 min', signs: ['Teacher', 'Student', 'Class']),
        UnitLesson(id: 'u3l3', title: 'Asking Questions', duration: '10 min', signs: ['What', 'Where', 'Please']),
        UnitLesson(id: 'u3l4', title: 'School Activities', duration: '12 min', signs: ['Read', 'Write', 'Thank You']),
      ],
    ),
    LessonUnit(
      id: 'u4', title: 'Family and Relationships',
      subtitle: 'Signs for family members and relationships', lessonCount: 5,
      progress: 0.0, skillFocus: 'Personal Connections',
      lessons: [
        UnitLesson(id: 'u4l1', title: 'Family Members', duration: '10 min', signs: ['Mother', 'Father', 'Sister']),
        UnitLesson(id: 'u4l2', title: 'Describing People', duration: '12 min', signs: ['Father', 'Tall', 'Young']),
        UnitLesson(id: 'u4l3', title: 'Ages and Birthdays', duration: '8 min', signs: ['Mother', 'Birthday', 'Old']),
        UnitLesson(id: 'u4l4', title: 'Relationships', duration: '10 min', signs: ['Friend', 'Love', 'Together']),
        UnitLesson(id: 'u4l5', title: 'Family Activities', duration: '12 min', signs: ['Mother', 'Eat', 'Play']),
      ],
    ),
  ];
}

class UnitLesson {
  final String id;
  final String title;
  final String duration;
  final List<String> signs;

  const UnitLesson({
    required this.id,
    required this.title,
    required this.duration,
    this.signs = const [],
  });
}

// ── Lesson-level content (intro screen only) ────────────────────────────────

class LessonContent {
  final String lessonId;
  final String learningGoal;
  final String estimatedTime;

  const LessonContent({
    required this.lessonId,
    required this.learningGoal,
    required this.estimatedTime,
  });

  static LessonContent? forLesson(String id) => _all[id];

  static const Map<String, LessonContent> _all = {
    'u1l1': LessonContent(lessonId: 'u1l1', estimatedTime: '8 min',
        learningGoal: 'Learn to sign HELLO and GOODBYE for everyday greetings.'),
    'u1l2': LessonContent(lessonId: 'u1l2', estimatedTime: '10 min',
        learningGoal: 'Introduce yourself by signing HELLO followed by your name sign.'),
    'u1l3': LessonContent(lessonId: 'u1l3', estimatedTime: '8 min',
        learningGoal: 'Express NICE TO MEET YOU after an introduction.'),
    'u1l4': LessonContent(lessonId: 'u1l4', estimatedTime: '10 min',
        learningGoal: 'Use PLEASE and FINE to ask politely and express how you are doing.'),
    'u1l5': LessonContent(lessonId: 'u1l5', estimatedTime: '12 min',
        learningGoal: 'Introduce a third person to a Deaf friend using HELLO and FRIEND.'),
    'u2l1': LessonContent(lessonId: 'u2l1', estimatedTime: '8 min',
        learningGoal: 'Use PLEASE and THANK YOU politely in everyday requests.'),
    'u2l2': LessonContent(lessonId: 'u2l2', estimatedTime: '7 min',
        learningGoal: 'Answer yes/no questions confidently using YES, NO, and MAYBE.'),
    'u2l3': LessonContent(lessonId: 'u2l3', estimatedTime: '10 min',
        learningGoal: 'Sign HELP and ask for assistance politely in any situation.'),
    'u2l4': LessonContent(lessonId: 'u2l4', estimatedTime: '12 min',
        learningGoal: 'Express feelings using SORRY, HAPPY, and SAD in real situations.'),
    'u3l1': LessonContent(lessonId: 'u3l1', estimatedTime: '10 min',
        learningGoal: 'Sign BOOK, PENCIL, and PAPER for use in classroom settings.'),
    'u3l2': LessonContent(lessonId: 'u3l2', estimatedTime: '8 min',
        learningGoal: 'Sign TEACHER, STUDENT, and CLASS to navigate school.'),
    'u3l3': LessonContent(lessonId: 'u3l3', estimatedTime: '10 min',
        learningGoal: 'Ask classroom questions using WHAT, WHERE, and PLEASE correctly.'),
    'u3l4': LessonContent(lessonId: 'u3l4', estimatedTime: '12 min',
        learningGoal: 'Sign READ, WRITE, and THANK YOU to discuss school activities.'),
    'u4l1': LessonContent(lessonId: 'u4l1', estimatedTime: '10 min',
        learningGoal: 'Sign MOTHER, FATHER, and SISTER when talking about family.'),
    'u4l2': LessonContent(lessonId: 'u4l2', estimatedTime: '12 min',
        learningGoal: 'Describe family members using FATHER, TALL, and YOUNG.'),
    'u4l3': LessonContent(lessonId: 'u4l3', estimatedTime: '8 min',
        learningGoal: 'Talk about age and birthdays using MOTHER, OLD, and BIRTHDAY.'),
    'u4l4': LessonContent(lessonId: 'u4l4', estimatedTime: '10 min',
        learningGoal: 'Sign FRIEND, LOVE, and TOGETHER to talk about relationships.'),
    'u4l5': LessonContent(lessonId: 'u4l5', estimatedTime: '12 min',
        learningGoal: 'Describe family activities using MOTHER, EAT, and PLAY.'),
  };
}

// ── Per-sign content (all lesson flow screens) ──────────────────────────────

class SignContent {
  final String signName;

  /// YOLO model label null if the model cannot detect this sign.
  final String? detectionLabel;

  // Watch screen
  final String handshape;
  final String placement;
  final String movement;
  final String facialExpression;
  final String thinkAboutIt;

  // Recognition quiz
  final String recognitionQuestion;
  final List<String> recognitionOptions;
  final int recognitionCorrectIndex;
  final String recognitionExplanation;

  // Context practice
  final String contextScenario;
  final List<String> contextOptions;
  final int contextCorrectIndex;
  final String contextExplanation;

  // Error analysis
  final String errorFeedback;

  const SignContent({
    required this.signName,
    this.detectionLabel,
    required this.handshape,
    required this.placement,
    required this.movement,
    required this.facialExpression,
    required this.thinkAboutIt,
    required this.recognitionQuestion,
    required this.recognitionOptions,
    required this.recognitionCorrectIndex,
    required this.recognitionExplanation,
    required this.contextScenario,
    required this.contextOptions,
    required this.contextCorrectIndex,
    required this.contextExplanation,
    required this.errorFeedback,
  });

  static SignContent? forSign(String name) => _all[name];

  /// All sign entries in curriculum order.
  static List<SignContent> get allSigns => _all.values.toList();

  /// Returns the YouTube video ID for a vocabulary sign, or null if unavailable.
  static String? youtubeIdForSign(String name) => _youtubeIds[name];

  /// YouTube video IDs for sign demonstrations.
  static const Map<String, String> _youtubeIds = {
    'Hello':     'FVjpLa8GqeM',
    'Goodbye':   '4e14uNAn2Ao',
    'Name':      'OzSFekmtyKw',
    'Nice':      'dBnilQEmbWw',
    'Thank You': 'IvRwNLNR4_w',
    'Please':    'UlBU161E6pY',
    'Fine':      'OHHKerxHJjQ',
    'Friend':    '6RRmIyhkMx0',
    'Yes':       '0usayvOXzHo',
    'No':        'yN-Bo3_EWQc',
    'Maybe':     '7bCApb-yubw',
    'Help':      'jENKp3DJ8tU',
    'Sorry':     'jRHDjxWJma0',
    'Happy':     'N5GLqFNS3Uo',
    'Sad':       'zfkQYQhrZ6Q',
    'Book':      'Kwvw-K6GYW8',
    'Pencil':    'j-YmJYyvLlY',
    'Paper':     'Zg7-DM25KIM',
    'Teacher':   'hJZhwVjk-eo',
    'Student':   'jrf2XYqjg2o',
    'Class':     'zYsmQgZRW0g',
    'What':      'FM2WMgJrAmk',
    'Where':     'qxh-EVaK6kY',
    'Read':      'LbNAbf-XhlM',
    'Write':     'rqBe62cqd6w',
    'Mother':    'qUkCg3rtEws',
    'Father':    'UnAiMqWCzNs',
    'Sister':    '1skSbSMPlMI',
    'Tall':      'rFKgJ911n3U',
    'Young':     'I02FA61xpCs',
    'Birthday':  'eB0lhZn8N9A',
    'Old':       'wmJfQSUsnQ8',
    'Love':      'lRIRPw5EdSU',
    'Together':  'iTOObV_mQvE',
    'Eat':       'OmylSinUxns',
    'Play':      'ODByBNyosxc',
    'Red':       'lDBvf8SoQuc',
    'Orange':    'Wt4p6qWgR1k',
    'Yellow':    'nK4_8-U-Y9I',
    'Blue':      't2T1_LMVTp8',
    'Green':     'WrkXE5l6udM',
    'White':     'v8h6mw4zGys',
    'Black':     'O5_4x8p5t4U',
    'Brown':     'PrniQgULERg',
    'Color':     'R0MW-QKaqeQ',
    'Big':       '4TjIP1OIvkU',
    'Small':     'RKnUlZ8bOzs',
    'More':      'nJwr-yWRdNQ',
    'Drink':     'LqJM7wcUixQ',
    'Water':     'e7_zscB_EVw',
    'Milk':      'PRtOyut96Ps',
    'Apple':     '3wIiujOP6Ag',
    'Cookie':    '6JW3ODCZkBQ',
    'Candy':     'EfJ4xLiX5IA',
    'Hungry':    '8ZOUoDZkAoQ',
    'Pizza':     'nrXA-R3VgJ8',
    'Soup':      'ALdtmqECO6Y',
    'Want':      'VnsXJs29sXQ',
    'Finish':    'gYB8ji01BLo',
    'Come':      'utAS6HfhNuQ',
    'Go':        'G4a8k_C92Oc',
    'Walk':      '5iv2XtBzogU',
    'Home':      'n0Xb58PVX_A',
    'Store':     'CPp1UOM-olA',
    'Work':      'GPU2D-8iJMQ',
    'Can':       'BVypOVtFnNk',
    'Need':      '7py1g9DyMcI',
    'Think':     'NdTKb3Kig88',
    'Good':      'tTDXplV6TKA',
    'Bad':       'prwtXZ1o2As',
    'Stop':      'A84uvLUmCVU',
    'Deaf':      'sP4e9vRUCYM',
    'Hearing':   'EOUkGLfYQ7M',
    'Sign':      'aEFfWgMsZSk',
    'Learn':     '78mzpzvN9tc',
    'Again':     'YEz-iyZ0kL0',
    'Meet':      'FC1R9kyegJY',
  };

  static const Map<String, SignContent> _all = {

    'Hello': SignContent(
      signName: 'Hello', detectionLabel: 'Hello',
      handshape: 'Open hand, fingers together',
      placement: 'Near the forehead',
      movement: 'Hand moves away from forehead in a smooth salute',
      facialExpression: 'Friendly eyebrows slightly raised',
      thinkAboutIt: 'The motion mirrors a casual salute starting near the forehead and moving outward. Why do you think greetings in many cultures involve the hand near the head?',
      recognitionQuestion: 'A signer raises their open hand to their forehead and sweeps it outward. What are they signing?',
      recognitionOptions: ['They want help', 'They are saying hello', 'They are saying goodbye', 'They are saying please'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'HELLO starts near the forehead and sweeps outward like a relaxed salute. The starting position near the head is the key identifier.',
      contextScenario: 'You arrive at a Deaf community event and spot someone you met before. How do you open the interaction?',
      contextOptions: ['Wait for them to approach', 'Wave from a distance', 'Make eye contact, sign HELLO', 'Sign THANK YOU'],
      contextCorrectIndex: 2,
      contextExplanation: 'In Deaf culture, making eye contact before signing is essential it signals you are ready to communicate. HELLO then opens the conversation.',
      errorFeedback: 'Sign B sweeps the hand down toward the chin instead of outward from the forehead. HELLO must originate near the forehead the chin placement belongs to other signs.',
    ),

    'Goodbye': SignContent(
      signName: 'Goodbye', detectionLabel: null,
      handshape: 'Open hand, all fingers extended',
      placement: 'In front of the face at shoulder height',
      movement: 'Fingers bend down and up repeatedly, or hand waves side to side',
      facialExpression: 'Warm, departing smile',
      thinkAboutIt: 'GOODBYE visually waves farewell. How does mimicking a natural wave help make this sign immediately understandable?',
      recognitionQuestion: 'Someone opens their hand and waves it loosely side to side near their face. What is this sign?',
      recognitionOptions: ['Come here', 'Hello', 'Goodbye', 'You are welcome'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'GOODBYE is a waving motion fingers bending or the hand swaying side to side. It directly mirrors the universal goodbye wave.',
      contextScenario: 'After a long conversation, your Deaf friend starts gathering their things to leave. What do you sign as they head out the door?',
      contextOptions: ['HELLO', 'PLEASE', 'SORRY', 'GOODBYE'],
      contextCorrectIndex: 3,
      contextExplanation: 'GOODBYE is always the closing sign when someone leaves. Maintaining eye contact and smiling while signing adds warmth to the farewell.',
      errorFeedback: 'Sign B uses only the index and middle fingers to wave. GOODBYE requires the full open hand all fingers extended together.',
    ),

    'Name': SignContent(
      signName: 'Name', detectionLabel: null,
      handshape: 'Both hands in H handshape index and middle fingers extended together',
      placement: 'In front of the body at mid chest',
      movement: 'Dominant H fingers tap on top of non dominant H fingers twice',
      facialExpression: 'Neutral, attentive expression',
      thinkAboutIt: 'NAME uses two H handshapes tapping together. What do you think helps people remember this sign the shape, the movement, or both?',
      recognitionQuestion: 'A signer crosses both hands with index and middle fingers extended, then taps them together twice. What concept is this?',
      recognitionOptions: ['Their age', 'A number', 'Their name', 'A question'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'NAME uses two H handshapes both index and middle fingers extended tapping together. The double tap distinguishes it from similar handshapes.',
      contextScenario: 'You have just been introduced to a Deaf person at a social event. They signed something to you and are waiting. Based on context, they most likely signed...',
      contextOptions: ['Can you help me?', 'Nice to meet you, what is your name?', 'Where are you from?', 'Do you know sign language?'],
      contextCorrectIndex: 1,
      contextExplanation: 'Asking for a name right after an introduction is the natural follow up in any culture. YOUR NAME is typically one of the first exchanges in ASL introductions.',
      errorFeedback: 'Sign B taps the fingertips together rather than the flat sides of the H fingers. NAME uses the finger shafts tapping, not just the tips.',
    ),

    'Nice': SignContent(
      signName: 'Nice', detectionLabel: null,
      handshape: 'Both hands flat, palms facing up',
      placement: 'Non dominant hand stays still in front of body; dominant hand above it',
      movement: 'Dominant flat hand slides forward across the non dominant palm',
      facialExpression: 'Pleased, warm expression',
      thinkAboutIt: 'NICE looks like you are smoothing something out making it "nice." How does the sliding motion physically reflect the idea of something being pleasant?',
      recognitionQuestion: 'One flat hand slides smoothly forward across the other open palm. What is being expressed?',
      recognitionOptions: ['Helping someone', 'Greeting someone', 'Something being pleasant or nice', 'Asking for something'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'NICE the dominant hand glides forward over the non dominant palm, like smoothing something out. The forward direction is the defining feature.',
      contextScenario: 'You have just been introduced to a new Deaf colleague. You want to express that it is a pleasure to meet them. What do you sign?',
      contextOptions: ['HELLO again', 'SORRY', 'NICE MEET YOU', 'THANK YOU'],
      contextCorrectIndex: 2,
      contextExplanation: 'NICE MEET YOU is the standard polite phrase after an introduction. NICE comes first it modifies the whole idea before MEET and YOU follow.',
      errorFeedback: 'Sign B slides the hand backward toward the body. NICE always moves forward away from the body. Backward movement would suggest a different meaning entirely.',
    ),

    'Thank You': SignContent(
      signName: 'Thank You', detectionLabel: 'Thank You',
      handshape: 'Flat hand, palm facing you',
      placement: 'Starts at the chin',
      movement: 'Hand moves forward away from the chin',
      facialExpression: 'Grateful, warm expression',
      thinkAboutIt: 'THANK YOU moves from your chin outward as if directing your gratitude toward the other person. How does that directionality reinforce the meaning?',
      recognitionQuestion: 'A signer touches their fingertips to their chin and moves their flat hand forward. What are they communicating?',
      recognitionOptions: ['Hello', 'Please', 'I understand', 'Thank you'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'THANK YOU starts at the chin and moves outward projecting your gratitude toward the other person. The direction reinforces the meaning.',
      contextScenario: 'A Deaf stranger helps you find something you dropped. You make eye contact with them. What is the most natural response?',
      contextOptions: ['Just nod', 'SORRY', 'HELLO', 'THANK YOU'],
      contextCorrectIndex: 3,
      contextExplanation: 'THANK YOU is the natural response to any act of kindness. A genuine facial expression carries as much meaning as the sign itself in Deaf culture.',
      errorFeedback: 'Sign B starts at the forehead instead of the chin. THANK YOU originates at the chin starting at the forehead is a completely different sign.',
    ),

    'Please': SignContent(
      signName: 'Please', detectionLabel: 'Please',
      handshape: 'Flat hand pressed against the chest',
      placement: 'Center of the chest',
      movement: 'Smooth circular motion on the chest',
      facialExpression: 'Polite, warm expression',
      thinkAboutIt: 'PLEASE sits at the chest the center of polite, heartfelt communication. How does placing this sign at the heart reinforce the idea of asking sincerely?',
      recognitionQuestion: 'A flat hand makes a slow circular motion at the center of the chest. What is this person asking for?',
      recognitionOptions: ['I am sorry', 'You are welcome', 'Please', 'I am happy'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'PLEASE flat hand circling on the chest. The fist in the same position means SORRY, so the open flat hand is the critical distinction.',
      contextScenario: 'You need to borrow a pen from a Deaf classmate. You tap their shoulder to get their attention, then sign...',
      contextOptions: ['THANK YOU', 'SORRY', 'PLEASE', 'HELLO'],
      contextCorrectIndex: 2,
      contextExplanation: 'PLEASE comes before the request just as in spoken language. It signals you are asking politely, not demanding.',
      errorFeedback: 'Sign B uses a fist instead of a flat hand. A fist circling on the chest means SORRY, not PLEASE. The handshape is everything here.',
    ),

    'Fine': SignContent(
      signName: 'Fine', detectionLabel: null,
      handshape: 'Open hand, thumb extended, other fingers spread',
      placement: 'At the chest',
      movement: 'Thumb taps the chest once',
      facialExpression: 'Content, neutral to positive expression',
      thinkAboutIt: 'FINE uses the thumb touching the chest a self referential, affirming gesture. How is this different from just nodding?',
      recognitionQuestion: 'A signer extends their thumb and touches it to their chest with a small tap. What are they expressing?',
      recognitionOptions: ['I am sad', 'I am tired', 'I am fine', 'I am hungry'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'FINE open hand with thumb touching the chest once. It is a self referential gesture meaning I am okay or doing well.',
      contextScenario: 'A Deaf acquaintance you barely know signs HOW YOU to you in passing. You are doing okay nothing special. The most appropriate response is...',
      contextOptions: ['HAPPY', 'SORRY', 'FINE', 'THANK YOU'],
      contextCorrectIndex: 2,
      contextExplanation: 'FINE is the neutral, honest casual response to HOW YOU. It is appropriate when you are doing okay but not particularly excited.',
      errorFeedback: 'Sign B taps the thumb to the chin instead of the chest. FINE is a chest level sign tapping the chin puts you in the territory of completely different signs.',
    ),

    'Friend': SignContent(
      signName: 'Friend', detectionLabel: 'Friend',
      handshape: 'Index fingers hooked together',
      placement: 'In front of the body',
      movement: 'Hook the index fingers together, then flip and switch which is on top',
      facialExpression: 'Warm, open expression',
      thinkAboutIt: 'FRIEND involves two fingers linking and switching representing a reciprocal bond. What does the switching motion say about the nature of friendship?',
      recognitionQuestion: 'Two index fingers hook together, then switch positions so each takes the other\'s place. What concept does this capture?',
      recognitionOptions: ['A teacher', 'A stranger', 'A friend', 'A family member'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'FRIEND index fingers hook and switch, representing a mutual, reciprocal relationship between two people.',
      contextScenario: 'You want to introduce someone important to you to your Deaf colleague. How do you describe the relationship?',
      contextOptions: ['STUDENT', 'TEACHER', 'MY FRIEND', 'SORRY'],
      contextCorrectIndex: 2,
      contextExplanation: 'MY FRIEND establishes the relationship before you give the name. In ASL, identifying the relationship first helps set context for the introduction.',
      errorFeedback: 'Sign B hooks the fingers but moves them up and down rather than switching which is on top. The switch is essential without it the sign is incomplete.',
    ),

    'Yes': SignContent(
      signName: 'Yes', detectionLabel: 'Yes',
      handshape: 'S handshape closed fist',
      placement: 'In front of the body',
      movement: 'Fist nods up and down from the wrist',
      facialExpression: 'Affirming slight nod of the head alongside the sign',
      thinkAboutIt: 'YES is a fist that nods physically mimicking a head nod. How does this physical echo between hand and head reinforce the sign\'s meaning?',
      recognitionQuestion: 'A signer makes a fist and bobs it up and down from the wrist. What is being communicated?',
      recognitionOptions: ['Maybe', 'I understand', 'No', 'Yes'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'YES the fist nods from the wrist, mirroring a head nod. It is one of ASL\'s most direct affirmative signs.',
      contextScenario: 'A Deaf friend invites you to join them for coffee and you are happy to go. How do you respond clearly?',
      contextOptions: ['Smile and shrug', 'MAYBE', 'PLEASE', 'YES'],
      contextCorrectIndex: 3,
      contextExplanation: 'YES is direct and unmistakable. Adding a genuine nod and smile reinforces your enthusiasm and makes the affirmation culturally warm.',
      errorFeedback: 'Sign B moves the entire forearm up and down. YES is a wrist only movement the arm stays still. Full arm movement looks like a different sign entirely.',
    ),

    'No': SignContent(
      signName: 'No', detectionLabel: 'No',
      handshape: 'Index and middle fingers extended, thumb extended',
      placement: 'In front of the body',
      movement: 'Index and middle fingers snap down to meet the thumb',
      facialExpression: 'Slight head shake facial grammar reinforces NO',
      thinkAboutIt: 'NO snaps the fingers together like closing off a possibility. How does the snapping motion physically represent saying no?',
      recognitionQuestion: 'A signer snaps their index and middle fingers down to meet their extended thumb. What are they signing?',
      recognitionOptions: ['Maybe', 'Stop', 'No', 'Help'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'NO index and middle fingers snap down to the thumb. Often paired with a slight head shake for emphasis.',
      contextScenario: 'A stranger approaches you and tries to hand you something you do not want. How do you decline clearly without being rude?',
      contextOptions: ['Say nothing', 'SORRY', 'NO', 'GOODBYE'],
      contextCorrectIndex: 2,
      contextExplanation: 'NO paired with a polite but clear expression is direct and respectful. The head shake reinforces the sign and is culturally appropriate.',
      errorFeedback: 'Sign B snaps only the index finger down. NO requires both the index AND middle finger together using one finger changes the handshape and the meaning.',
    ),

    'Maybe': SignContent(
      signName: 'Maybe', detectionLabel: null,
      handshape: 'Both open hands, palms facing up',
      placement: 'In front of the body',
      movement: 'Hands alternate up and down, like two sides of a scale weighing options',
      facialExpression: 'Uncertain slightly pursed lips or raised brows',
      thinkAboutIt: 'MAYBE looks like two scales balancing weighing two possibilities. How does the alternating motion physically mirror the idea of uncertainty?',
      recognitionQuestion: 'Both open palms alternate up and down like two sides of a scale, while the signer\'s expression looks uncertain. What is this sign?',
      recognitionOptions: ['Yes', 'No', 'I do not know', 'Maybe'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'MAYBE both palms alternating up and down, like weighing two options. The uncertain facial expression is part of the grammar.',
      contextScenario: 'A Deaf classmate asks if you are coming to the study group tomorrow. You have not decided yet. How do you respond honestly?',
      contextOptions: ['YES', 'NO', 'SORRY', 'MAYBE'],
      contextCorrectIndex: 3,
      contextExplanation: 'MAYBE is the honest response when you are genuinely unsure. You can follow it with DEPENDS or I WILL LET YOU KNOW to give more context.',
      errorFeedback: 'Sign B moves both hands in the same direction at the same time. MAYBE alternates one goes up as the other goes down. Simultaneous movement looks like a different sign.',
    ),

    'Help': SignContent(
      signName: 'Help', detectionLabel: null,
      handshape: 'Dominant A handshape (fist, thumb up) resting on open non dominant palm',
      placement: 'In front of the body at waist level',
      movement: 'Both hands rise upward together',
      facialExpression: 'Eyebrows raised asking expression',
      thinkAboutIt: 'HELP looks like one hand lifting another up. How does that visual metaphor of lifting connect to what helping someone actually means?',
      recognitionQuestion: 'A thumbs up fist rests on an open palm, and both hands rise together. What is being signed?',
      recognitionOptions: ['Thank you', 'Please', 'Help', 'Together'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'HELP the A handshape sits on the open palm and both rise together, as if one hand is literally lifting the other.',
      contextScenario: 'During a conversation, a Deaf person signs something too quickly and you miss it. What is the most respectful thing to sign?',
      contextOptions: ['Walk away', 'SORRY then HELP PLEASE', 'NO', 'Just nod'],
      contextCorrectIndex: 1,
      contextExplanation: 'SORRY followed by HELP (or AGAIN) is the respectful, honest response. It shows you want to communicate not that you are giving up.',
      errorFeedback: 'Sign B raises only the thumbs up fist by itself. HELP is a two handed sign the open palm supporting from below is not optional.',
    ),

    'Sorry': SignContent(
      signName: 'Sorry', detectionLabel: 'Sorry',
      handshape: 'A handshape closed fist',
      placement: 'Center of the chest',
      movement: 'Circular motion on the chest',
      facialExpression: 'Regretful slight downward gaze, brow slightly furrowed',
      thinkAboutIt: 'SORRY and PLEASE both circle on the chest. The fist versus flat hand is the only difference. Why do you think this small distinction carries such significant meaning?',
      recognitionQuestion: 'A closed fist rotates in a slow circle at the center of the chest. What emotion is being expressed?',
      recognitionOptions: ['Please', 'Happy', 'Sorry', 'Thank you'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'SORRY the fist rotating on the chest. PLEASE uses the same location but with a flat hand. The fist is what makes this an apology.',
      contextScenario: 'You accidentally knock over a Deaf person\'s coffee. They look at you. What do you sign immediately?',
      contextOptions: ['PLEASE', 'HELLO', 'SORRY', 'THANK YOU'],
      contextCorrectIndex: 2,
      contextExplanation: 'SORRY with a genuine, regretful expression is both culturally appropriate and clearly communicates your apology. Facial expression carries half the meaning.',
      errorFeedback: 'Sign B uses a flat hand on the chest. A flat hand circling on the chest means PLEASE not SORRY. Using a closed fist is the only thing that makes this an apology.',
    ),

    'Happy': SignContent(
      signName: 'Happy', detectionLabel: null,
      handshape: 'Open flat hand, palm facing you',
      placement: 'At the chest',
      movement: 'Hand brushes upward on the chest in a circular motion, repeated',
      facialExpression: 'Genuine smile the facial expression is essential here',
      thinkAboutIt: 'HAPPY brushes upward as if lifting your heart. How does the upward direction communicate a positive emotional state?',
      recognitionQuestion: 'An open hand brushes upward against the chest repeatedly with a bright expression. What feeling is being shown?',
      recognitionOptions: ['Tired', 'Sad', 'Angry', 'Happy'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'HAPPY the hand brushes upward on the chest, as if lifting your feelings upward. The upward direction and genuine smile are both essential.',
      contextScenario: 'You just got exciting news and a Deaf friend notices your expression and signs HOW YOU. You sign back...',
      contextOptions: ['FINE', 'SORRY', 'PLEASE', 'HAPPY'],
      contextCorrectIndex: 3,
      contextExplanation: 'HAPPY is the natural, expressive response to good news. The intensity of the brushing motion and the brightness of your expression can show just how happy you are.',
      errorFeedback: 'Sign B brushes the hand downward. HAPPY always moves upward the upward motion is what conveys the lift of a positive emotion. Downward belongs to SAD.',
    ),

    'Sad': SignContent(
      signName: 'Sad', detectionLabel: null,
      handshape: 'Both open hands, fingers spread, palms facing you',
      placement: 'In front of the face',
      movement: 'Hands move downward in front of the face',
      facialExpression: 'Downturned mouth, drooping expression the face carries most of the meaning',
      thinkAboutIt: 'SAD drags hands downward in front of the face like a falling expression. How does gravity and downward motion relate to negative emotions?',
      recognitionQuestion: 'Both open hands move slowly downward in front of the face, as if pulling an expression down. What is being communicated?',
      recognitionOptions: ['Bored', 'Sad', 'Angry', 'Tired'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'SAD both hands drop in front of the face, mirroring a fallen, downcast expression. The face must reflect the emotion it is part of the sign.',
      contextScenario: 'A Deaf friend just told you some difficult news. They are clearly upset. To show empathy, you sign...',
      contextOptions: ['HAPPY', 'SORRY and SAD', 'FINE', 'GOODBYE'],
      contextCorrectIndex: 1,
      contextExplanation: 'SORRY + SAD shows you recognise their pain and empathise. In Deaf culture, acknowledging feelings directly is more meaningful than immediately trying to fix them.',
      errorFeedback: 'Sign B uses only one hand dropping down. SAD uses both hands simultaneously in front of the face. One hand alone does not carry the same emotional weight.',
    ),

    'Book': SignContent(
      signName: 'Book', detectionLabel: null,
      handshape: 'Both hands flat, palms pressed together',
      placement: 'In front of the body at chest height',
      movement: 'Open hands outward like opening a book',
      facialExpression: 'Neutral, focused',
      thinkAboutIt: 'BOOK mimics the physical act of opening a book. Many object signs in ASL mime how the object is used. What other everyday objects might have signs that work this way?',
      recognitionQuestion: 'A signer holds both palms pressed together, then opens them outward like opening a cover. What object is this?',
      recognitionOptions: ['A door', 'A box', 'A book', 'A window'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'BOOK both palms open outward like opening a physical book. It directly mimes the action of opening a cover.',
      contextScenario: 'Your teacher signs something and points to the stack on the desk. You need to take out the right object for today\'s lesson. You reach for your...',
      contextOptions: ['PENCIL', 'PAPER', 'BOOK', 'Chair'],
      contextCorrectIndex: 2,
      contextExplanation: 'BOOK is the natural sign for any reading material. Its mime of opening a cover makes it one of the most intuitive classroom signs.',
      errorFeedback: 'Sign B opens the hands upward like opening a box lid. BOOK opens to the sides exactly as a real book does. Upward opening is a different sign.',
    ),

    'Pencil': SignContent(
      signName: 'Pencil', detectionLabel: null,
      handshape: 'Dominant hand mimics holding a pencil tip near the mouth, then writing',
      placement: 'Near the mouth first, then moves to write on the non dominant palm',
      movement: 'Mime licking a pencil tip near the mouth, then make a writing motion on the other palm',
      facialExpression: 'Neutral, casual',
      thinkAboutIt: 'PENCIL mimes the old habit of licking a pencil tip before writing. Even if you do not do this, why does the mime make the sign recognizable?',
      recognitionQuestion: 'A signer mimes licking a pencil tip near their mouth, then makes small writing motions across their other palm. What is this?',
      recognitionOptions: ['Write', 'Draw', 'Pencil', 'Paper'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'PENCIL the lick near the mouth distinguishes it from WRITE. Without that initial mouth gesture, you are just signing WRITE.',
      contextScenario: 'You are in class and need to write something but your pen has run out. You want to ask a Deaf classmate to lend you theirs. You sign...',
      contextOptions: ['WRITE', 'PAPER', 'PENCIL', 'BOOK'],
      contextCorrectIndex: 2,
      contextExplanation: 'PENCIL is specific. Signing WRITE only describes the action not the tool. Using the right sign shows vocabulary precision.',
      errorFeedback: 'Sign B goes straight to the writing motion without the lick near the mouth. That makes it WRITE, not PENCIL. The mouth gesture is the distinguishing feature.',
    ),

    'Paper': SignContent(
      signName: 'Paper', detectionLabel: null,
      handshape: 'Both hands flat, palms down',
      placement: 'Non dominant hand stays still; dominant hand moves across it',
      movement: 'Dominant hand brushes sideways across the non dominant palm twice',
      facialExpression: 'Neutral',
      thinkAboutIt: 'PAPER looks like smoothing out a flat sheet. How does the flat, horizontal brushing motion relate to what paper looks and feels like?',
      recognitionQuestion: 'A flat dominant hand brushes sideways across the other flat open palm two times. What does this represent?',
      recognitionOptions: ['Cleaning a surface', 'Writing something', 'Paper', 'A book'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'PAPER the brushing motion represents smoothing out a flat sheet. The horizontal sideways movement across the palm is the defining feature.',
      contextScenario: 'Your teacher asks everyone to hand in their assignment. What object do you pick up and pass forward?',
      contextOptions: ['BOOK', 'PENCIL', 'PAPER', 'Chair'],
      contextCorrectIndex: 2,
      contextExplanation: 'PAPER refers to any flat sheet homework, worksheets, documents. The flat, brushing gesture is visually intuitive and easy to remember.',
      errorFeedback: 'Sign B makes circular motions instead of straight sideways brushes. PAPER is a directional motion side to side across the palm, not circular.',
    ),

    'Teacher': SignContent(
      signName: 'Teacher', detectionLabel: 'Teacher',
      handshape: 'Both hands in flat O shape near the temples',
      placement: 'Near the temples, on each side of the head',
      movement: 'Move both hands outward from temples, then add PERSON marker (flat hands brushing down)',
      facialExpression: 'Respectful, neutral expression',
      thinkAboutIt: 'TEACHER begins near the temples where knowledge is held and moves outward, as if sharing it. How does this spatial image reflect what a teacher does?',
      recognitionQuestion: 'Both hands in a flat O shape move outward from the temples, then brush downward. What role does this person play?',
      recognitionOptions: ['Student', 'Parent', 'Teacher', 'Friend'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'TEACHER flat O hands move outward from the temples (sharing knowledge), followed by the PERSON marker brushing downward.',
      contextScenario: 'You arrive late to class and need to apologise to the person in charge of the room. You sign SORRY and then address...',
      contextOptions: ['STUDENT', 'FRIEND', 'MOTHER', 'TEACHER'],
      contextCorrectIndex: 3,
      contextExplanation: 'SORRY TEACHER is the respectful sequence acknowledging the apology and directing it at the right person. Always greet or address before speaking.',
      errorFeedback: 'Sign B skips the PERSON marker at the end. In ASL, occupational signs like TEACHER require the PERSON marker omitting it makes the sign grammatically incomplete.',
    ),

    'Student': SignContent(
      signName: 'Student', detectionLabel: null,
      handshape: 'Dominant open hand, non dominant hand flat palm up',
      placement: 'Non dominant palm stays; dominant hand moves from palm to forehead',
      movement: 'Dominant hand takes something from the non dominant palm and brings it to the forehead',
      facialExpression: 'Attentive, open expression',
      thinkAboutIt: 'STUDENT looks like picking up knowledge from a book and bringing it to your head. How does this direction of movement convey the idea of learning?',
      recognitionQuestion: 'A signer takes something from their open palm and brings it up to their forehead. What concept is this showing?',
      recognitionOptions: ['Thinking hard', 'Memorising something', 'Being a student', 'Reading a book'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'STUDENT picking knowledge from the open palm (like a book) and bringing it to the forehead. The direction of movement shows the learning process.',
      contextScenario: 'You are explaining your role at school to a new Deaf acquaintance. You sign I and then...',
      contextOptions: ['TEACHER', 'FRIEND', 'STUDENT', 'BOOK'],
      contextCorrectIndex: 2,
      contextExplanation: 'I + STUDENT clearly establishes your role. In ASL, the subject (I) typically comes first to set the topic before describing who you are.',
      errorFeedback: 'Sign B brings the hand to the chest instead of the forehead. STUDENT ends at the forehead that is where learning is deposited. The chest placement changes the meaning.',
    ),

    'Class': SignContent(
      signName: 'Class', detectionLabel: null,
      handshape: 'Both C handshapes curved, like holding a cylinder',
      placement: 'In front of the body',
      movement: 'Both C hands start together and arc outward to the sides',
      facialExpression: 'Neutral, matter of fact',
      thinkAboutIt: 'CLASS shows a group of people arranged in an arc like students seated in a semicircle. How does this spatial representation convey that CLASS is about a group?',
      recognitionQuestion: 'Both curved C hands start close together and arc outward to the sides. What is being signed?',
      recognitionOptions: ['A group of friends', 'A team', 'A class', 'A circle'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'CLASS the C handshapes arc outward, representing a group of people arranged in space. It shows the collective nature of a class.',
      contextScenario: 'You are telling a Deaf friend about your daily routine. In the mornings, you go where?',
      contextOptions: ['BOOK', 'TEACHER', 'HOME', 'CLASS'],
      contextCorrectIndex: 3,
      contextExplanation: 'CLASS is the natural sign for the place you attend lessons. You can combine it with a time sign like MORNING for a full natural sentence.',
      errorFeedback: 'Sign B uses flat hands instead of C handshapes. The curved C shape represents people arranged in a group. Flat hands change the spatial meaning entirely.',
    ),

    'What': SignContent(
      signName: 'What', detectionLabel: null,
      handshape: 'Both open hands, palms up, fingers spread',
      placement: 'In front of the body, slightly forward',
      movement: 'Hands shake slightly side to side',
      facialExpression: 'Brows furrowed this is grammatically required for WH questions in ASL',
      thinkAboutIt: 'WHAT uses an open, uncertain gesture palms up, slightly shaking. How is this open gesture different from signs that are more definitive?',
      recognitionQuestion: 'Both open palms shake slightly side to side and the signer furrows their brows. What kind of word is this?',
      recognitionOptions: ['A greeting', 'A polite request', 'A question word meaning what', 'An expression of surprise'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'WHAT open palms shaking with furrowed brows. The facial expression is grammatically required for all WH questions in ASL.',
      contextScenario: 'A Deaf classmate signs something quickly and you catch the topic but miss the detail. To ask them to clarify the specific thing they mentioned, you sign...',
      contextOptions: ['WHERE', 'SORRY AGAIN', 'WHAT', 'HELLO'],
      contextCorrectIndex: 2,
      contextExplanation: 'WHAT targets the missing detail directly. It is more efficient than asking for a full repeat, and shows you were paying attention.',
      errorFeedback: 'Sign B holds the palms still without the slight shake. WHAT requires the hands to move the shaking motion is part of what signals it as a question word.',
    ),

    'Where': SignContent(
      signName: 'Where', detectionLabel: null,
      handshape: 'Index finger extended',
      placement: 'In front of the body',
      movement: 'Index finger wags or shakes side to side',
      facialExpression: 'Brows furrowed WH question facial grammar',
      thinkAboutIt: 'WHERE wags the finger as if searching different directions. How does the wagging motion physically convey the idea of looking for a location?',
      recognitionQuestion: 'A signer wags their index finger side to side with furrowed brows. What are they asking about?',
      recognitionOptions: ['Who someone is', 'When something happened', 'A location or place', 'How something is done'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'WHERE the index finger wags as if searching in different directions for a location. Furrowed brows are the required facial grammar.',
      contextScenario: 'You are trying to find the new classroom and you stop a Deaf person in the hallway. What do you sign?',
      contextOptions: ['WHAT CLASS', 'SORRY TEACHER', 'WHERE CLASS', 'HELLO STUDENT'],
      contextCorrectIndex: 2,
      contextExplanation: 'WHERE CLASS is the direct, natural question. You can point in different directions after signing WHERE to help narrow down the location.',
      errorFeedback: 'Sign B wags the finger up and down instead of side to side. WHERE is a horizontal wagging motion. Vertical wagging belongs to other question signs.',
    ),

    'Read': SignContent(
      signName: 'Read', detectionLabel: null,
      handshape: 'Dominant V handshape (index and middle fingers); non dominant hand flat',
      placement: 'Non dominant hand represents a page; dominant V moves across it',
      movement: 'V handshape moves across the non dominant palm, as if eyes scanning text',
      facialExpression: 'Focused, concentrated expression',
      thinkAboutIt: 'READ uses the V hand like two eyes scanning down a page. How does this visual metaphor help you remember what the sign represents?',
      recognitionQuestion: 'A V shaped hand two extended fingers moves across an open palm as if scanning lines. What activity is this?',
      recognitionOptions: ['Drawing', 'Counting', 'Writing', 'Reading'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'READ the V hand represents two eyes scanning down a page. The movement across the open palm mimics eyes reading lines of text.',
      contextScenario: 'Your teacher tells everyone to be quiet and focus on the text in front of them. What are students expected to do?',
      contextOptions: ['Write answers', 'Play quietly', 'Eat their lunch', 'Read the passage'],
      contextCorrectIndex: 3,
      contextExplanation: 'READ suggests focused, quiet engagement with text. The sign is self explanatory two eyes scanning a page.',
      errorFeedback: 'Sign B uses all five fingers spread across the palm. READ uses exactly two fingers representing two eyes. Using a full hand removes the specific visual metaphor.',
    ),

    'Write': SignContent(
      signName: 'Write', detectionLabel: null,
      handshape: 'Dominant hand in modified O or G shape, as if holding a pen',
      placement: 'Non dominant hand flat as a surface; dominant hand writes on it',
      movement: 'Dominant hand makes small writing motions across the non dominant palm',
      facialExpression: 'Focused, task oriented',
      thinkAboutIt: 'WRITE mimes the physical act of writing on a surface. What does it tell you about how sign language creates signs for abstract actions?',
      recognitionQuestion: 'One hand mimes holding a pen and makes small script like motions across the other palm. What is being shown?',
      recognitionOptions: ['Drawing a picture', 'Signing a name', 'Writing', 'Erasing something'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'WRITE the dominant hand mimes writing across the non dominant palm. The small, precise movements distinguish it from larger drawing motions.',
      contextScenario: 'Your teacher asks everyone to complete the questions on the handout. What is the expected activity?',
      contextOptions: ['Read aloud', 'Draw diagrams', 'Write answers', 'Put paper away'],
      contextCorrectIndex: 2,
      contextExplanation: 'WRITE is the appropriate sign for completing written assignments. Compare it to READ READ scans with the V hand (eyes), WRITE scripts with a pen shaped hand.',
      errorFeedback: 'Sign B makes large sweeping arm motions. WRITE is small and precise like actual handwriting. Large movements suggest drawing, not writing.',
    ),

    'Mother': SignContent(
      signName: 'Mother', detectionLabel: 'Mother',
      handshape: 'Open hand, thumb touching the chin',
      placement: 'At the chin',
      movement: 'Thumb taps the chin twice',
      facialExpression: 'Warm, family oriented expression',
      thinkAboutIt: 'MOTHER taps the chin female signs in ASL are generally placed at or below the nose. FATHER taps the forehead. How does this high/low distinction help organise family signs?',
      recognitionQuestion: 'An open hand taps the thumb twice against the chin. Who is this sign referring to?',
      recognitionOptions: ['Sister', 'Teacher', 'Father', 'Mother'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'MOTHER the thumb taps the chin. Female family signs are placed at or below the nose in ASL. Compare to FATHER, which is at the forehead.',
      contextScenario: 'You are showing a Deaf friend a family photo and pointing to the woman who raised you. You sign...',
      contextOptions: ['TEACHER', 'FRIEND', 'SISTER', 'MOTHER'],
      contextCorrectIndex: 3,
      contextExplanation: 'MOTHER is the specific sign for the female parent. Signing MOTHER first establishes the relationship you can then describe her further.',
      errorFeedback: 'Sign B places the thumb at the forehead instead of the chin. Forehead placement means FATHER. Chin = female side, forehead = male side this distinction is essential.',
    ),

    'Father': SignContent(
      signName: 'Father', detectionLabel: 'Father',
      handshape: 'Open hand, thumb touching the forehead',
      placement: 'At the forehead',
      movement: 'Thumb taps the forehead twice',
      facialExpression: 'Respectful, family oriented expression',
      thinkAboutIt: 'FATHER taps the forehead male signs are generally placed at or above the nose level. How does this spatial pattern make the gender distinction systematic?',
      recognitionQuestion: 'An open hand taps the thumb twice against the forehead. Who does this sign represent?',
      recognitionOptions: ['Brother', 'Teacher', 'Mother', 'Father'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'FATHER thumb tapping the forehead. Male family signs are placed at or above the nose. The forehead location is the key distinguisher from MOTHER.',
      contextScenario: 'You are describing your family to a Deaf friend. You want to talk about the male parent who raised you. You sign...',
      contextOptions: ['TEACHER', 'FRIEND', 'MOTHER', 'FATHER'],
      contextCorrectIndex: 3,
      contextExplanation: 'FATHER is the specific sign for the male parent. Male signs live at the forehead, female signs at the chin this organises the whole family sign system.',
      errorFeedback: 'Sign B taps the thumb to the chin. Chin placement means MOTHER, not FATHER. These two signs are mirror images of each other the location is everything.',
    ),

    'Sister': SignContent(
      signName: 'Sister', detectionLabel: null,
      handshape: 'L handshape (thumb and index finger extended), starts near chin then joins non dominant fist',
      placement: 'Begins at the chin (female marker), then in front of the body',
      movement: 'L hand near chin then lands alongside or on the non dominant hand (same/sibling)',
      facialExpression: 'Warm, family expression',
      thinkAboutIt: 'SISTER combines the female marker (chin area) with a same/sibling gesture. What does the "same" element tell you about the sibling relationship?',
      recognitionQuestion: 'An L handshape starts near the chin, then lands alongside or on top of the other hand. What relationship is this?',
      recognitionOptions: ['A female teacher', 'A mother', 'A female friend', 'A sister'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'SISTER starts at the chin (female marker) then joins the other hand in a same/sibling gesture. The two elements together mean female sibling.',
      contextScenario: 'You are describing your family and mention the girl who grew up in the same house as you. You sign...',
      contextOptions: ['MOTHER', 'FRIEND', 'BROTHER', 'SISTER'],
      contextCorrectIndex: 3,
      contextExplanation: 'SISTER specifically encodes both the gender (chin marker) and the sibling relationship (joining gesture). Using it shows precision in your signing.',
      errorFeedback: 'Sign B starts at the forehead before joining the other hand. Forehead origin would indicate a male relation. SISTER always begins at the chin.',
    ),

    'Tall': SignContent(
      signName: 'Tall', detectionLabel: null,
      handshape: 'Flat hand, palm facing down',
      placement: 'Hand held high, indicating height in physical space',
      movement: 'Flat hand held at a raised level the height of the hand represents the height of the person',
      facialExpression: 'Impressed or matter of fact expression',
      thinkAboutIt: 'TALL uses a high horizontal hand to mark height in space. How does using physical space to show size make this sign immediately intuitive?',
      recognitionQuestion: 'A flat palm down hand is held high in the air. What physical quality is being described?',
      recognitionOptions: ['Something being far away', 'Something being expensive', 'Someone being tall', 'Something being on a shelf'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'TALL the flat hand held high represents height in physical space. The position of the hand is literally the meaning.',
      contextScenario: 'Your friend asks you to describe your father. The first thing you notice about him is his height. You sign FATHER, then...',
      contextOptions: ['OLD', 'YOUNG', 'SHORT', 'TALL'],
      contextCorrectIndex: 3,
      contextExplanation: 'Descriptors like TALL typically follow the subject in ASL. FATHER TALL reads naturally as \'my father is tall.\'',
      errorFeedback: 'Sign B holds the hand low, near waist height. Low hand position means SHORT, not TALL. The actual height of your hand in space is the entire meaning of this sign.',
    ),

    'Young': SignContent(
      signName: 'Young', detectionLabel: null,
      handshape: 'Both open hands, fingers bent at first knuckle',
      placement: 'At the shoulders and upper chest area',
      movement: 'Hands brush upward on the upper chest/shoulders repeatedly',
      facialExpression: 'Light, energetic expression',
      thinkAboutIt: 'YOUNG brushes upward on the chest like the energy of youth rising. How does this upward, energetic motion differ from signs for OLD?',
      recognitionQuestion: 'Both bent finger hands brush upward against the upper chest and shoulders with a light, energetic motion. What quality is this?',
      recognitionOptions: ['Being tired', 'Being old', 'Being young', 'Being strong'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'YOUNG the upward brushing at the shoulders suggests rising energy and vitality. The movement direction is the key upward equals youthful.',
      contextScenario: 'You are describing a relative who is a teenager. After signing their name, you add...',
      contextOptions: ['OLD', 'TALL', 'SORRY', 'YOUNG'],
      contextCorrectIndex: 3,
      contextExplanation: 'YOUNG follows naturally after establishing who you are talking about. It describes youthfulness without any negative connotation.',
      errorFeedback: 'Sign B brushes the hands downward across the chest. Downward brushing conveys a different feeling entirely YOUNG must move upward.',
    ),

    'Birthday': SignContent(
      signName: 'Birthday', detectionLabel: null,
      handshape: 'Dominant bent middle finger extended, other fingers closed',
      placement: 'Middle finger touches lips first, then taps the non dominant palm',
      movement: 'Bent middle finger touches lip, then taps the non dominant palm',
      facialExpression: 'Happy, celebratory expression',
      thinkAboutIt: 'BIRTHDAY combines elements of BIRTH and DAY. How does thinking of compound signs in terms of their components help you remember them?',
      recognitionQuestion: 'A signer touches their bent middle finger to their lips, then taps it on their open palm. What occasion is this?',
      recognitionOptions: ['Eating food', 'A holiday', 'A birthday', 'A performance'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'BIRTHDAY a compound of BIRTH (middle finger from lips) and DAY (tapping the palm). The bent middle finger is the critical handshape.',
      contextScenario: 'Your Deaf friend signs something and you notice they look excited and mention a date coming up. They are most likely signing about...',
      contextOptions: ['A test', 'Their birthday', 'A classroom rule', 'A homework deadline'],
      contextCorrectIndex: 1,
      contextExplanation: 'YOUR BIRTHDAY is one of the most natural topics when someone is excited about an upcoming date. Knowing this sign helps you engage meaningfully.',
      errorFeedback: 'Sign B uses the index finger instead of the middle finger. BIRTHDAY requires the bent middle finger specifically using the index finger changes the sign entirely.',
    ),

    'Old': SignContent(
      signName: 'Old', detectionLabel: null,
      handshape: 'S handshape (fist) starting at the chin',
      placement: 'Starts at the chin',
      movement: 'Hand drops downward, miming the gesture of stroking a long beard',
      facialExpression: 'Wise, measured expression',
      thinkAboutIt: 'OLD mimes pulling a long beard downward from the chin. Beards as symbols of wisdom appear across many cultures. Why do you think this image was chosen for this sign?',
      recognitionQuestion: 'A signer makes a fist at the chin and pulls it downward as if stroking a long beard. What quality is this?',
      recognitionOptions: ['Being sad', 'Being wise', 'Being old', 'Being tired'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'OLD the downward fist from the chin mimes stroking a long beard. The starting position at the chin and the downward pull are both essential.',
      contextScenario: 'You are describing an elderly family member to a Deaf friend. After signing their relationship to you, you add...',
      contextOptions: ['YOUNG', 'HAPPY', 'TALL', 'OLD'],
      contextCorrectIndex: 3,
      contextExplanation: 'OLD follows naturally after establishing who you are describing. In ASL, it carries no negative connotation it is a straightforward descriptor.',
      errorFeedback: 'Sign B moves the fist upward from the chin. OLD always pulls downward it mimes the weight and length of a long beard. Upward movement does not carry the same meaning.',
    ),

    'Love': SignContent(
      signName: 'Love', detectionLabel: null,
      handshape: 'Both arms crossed over the chest',
      placement: 'At the chest, centered at the heart',
      movement: 'Cross arms and hug them to the chest',
      facialExpression: 'Warm, sincere expression the face carries significant meaning here',
      thinkAboutIt: 'LOVE crosses both arms over the heart a universal symbol of affection. How does using the chest as the location reinforce the emotional nature of this sign?',
      recognitionQuestion: 'A signer crosses both arms over their chest and hugs them inward. What are they expressing?',
      recognitionOptions: ['Being cold', 'Feeling sorry', 'Being proud', 'Love'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'LOVE both arms crossed over the heart, hugging inward. It is one of ASL\'s most expressive and universally recognised signs.',
      contextScenario: 'At the end of a video call with a Deaf family member, you want to close warmly. What do you sign just before goodbye?',
      contextOptions: ['SORRY', 'PLEASE', 'FINE', 'I LOVE YOU'],
      contextCorrectIndex: 3,
      contextExplanation: 'I LOVE YOU (crossed arms or the one handed ILY sign) is a warm, meaningful way to close with family. It expresses genuine affection.',
      errorFeedback: 'Sign B crosses only one arm across the chest. LOVE uses both arms fully crossed one arm alone is incomplete and does not carry the same meaning.',
    ),

    'Together': SignContent(
      signName: 'Together', detectionLabel: null,
      handshape: 'Both A handshapes (fists) with thumbs up',
      placement: 'In front of the body',
      movement: 'Both fists move in a circle together, staying close to each other',
      facialExpression: 'Inclusive, warm expression',
      thinkAboutIt: 'TOGETHER keeps both fists moving in unison literally as one. How does synchronized movement between two hands communicate togetherness?',
      recognitionQuestion: 'Both fists circle together in front of the body, staying close and moving in sync. What concept is being shown?',
      recognitionOptions: ['Working hard', 'Being confused', 'Doing something together', 'Agreeing with someone'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'TOGETHER both fists circling in unison, literally as one. The synchronized movement between both hands carries the meaning.',
      contextScenario: 'You want to invite a Deaf friend to walk to class with you instead of going alone. You sign...',
      contextOptions: ['SORRY', 'GOODBYE', 'WE GO TOGETHER', 'PLEASE HELP'],
      contextCorrectIndex: 2,
      contextExplanation: 'WE + GO + TOGETHER is a natural sentence structure in ASL subject first, then the action and manner. It is warm and direct.',
      errorFeedback: 'Sign B moves both fists in opposite directions one up as one goes down. TOGETHER requires both fists moving in the same circular direction at the same time.',
    ),

    'Eat': SignContent(
      signName: 'Eat', detectionLabel: null,
      handshape: 'Dominant hand in a flat O shape (fingers touching thumb)',
      placement: 'At the mouth',
      movement: 'Hand moves toward the mouth repeatedly, as if bringing food',
      facialExpression: 'Natural, neutral or content expression',
      thinkAboutIt: 'EAT mimes bringing food to the mouth a universal gesture that exists across many cultures. Why do you think iconic mimed signs are often the easiest to remember?',
      recognitionQuestion: 'A signer brings a bunched finger hand to their mouth repeatedly. What activity is this showing?',
      recognitionOptions: ['Brushing teeth', 'Drinking water', 'Eating', 'Talking'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'EAT the flat O hand moves toward the mouth, directly miming bringing food to your lips. It is one of ASL\'s most iconic mime based signs.',
      contextScenario: 'Your family is gathered around the table and the food has just been served. What is everyone about to do?',
      contextOptions: ['PLAY', 'WRITE', 'DRINK', 'EAT'],
      contextCorrectIndex: 3,
      contextExplanation: 'EAT is the natural, obvious sign here. The sign can be modified faster movements suggest eating quickly, slower suggests savoring a meal.',
      errorFeedback: 'Sign B brings the hand to the chin rather than the mouth. EAT targets the mouth specifically the chin placement shifts the sign toward a different meaning.',
    ),

    'Play': SignContent(
      signName: 'Play', detectionLabel: null,
      handshape: 'Both hands in Y handshape (thumb and pinky extended)',
      placement: 'In front of the body',
      movement: 'Both Y hands shake/wiggle loosely back and forth from the wrist',
      facialExpression: 'Fun, energetic, light expression',
      thinkAboutIt: 'PLAY uses the Y handshape in a loose, free swinging motion. How does the casual, unrestrained movement of this sign reflect the nature of play itself?',
      recognitionQuestion: 'Both hands in a Y shape shake loosely from the wrists with a light, relaxed energy. What are they signing?',
      recognitionOptions: ['Working', 'Resting', 'Dancing', 'Playing'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'PLAY the Y handshape wiggling loosely from the wrists suggests free, joyful movement. The relaxed, casual motion is very different from structured signs.',
      contextScenario: 'After finishing homework, your sibling wants to do something fun. They sign...',
      contextOptions: ['EAT', 'WRITE', 'SORRY', 'PLAY'],
      contextCorrectIndex: 3,
      contextExplanation: 'PLAY is the natural sign for unstructured fun games, sports, or just hanging out. The loose wrist motion reflects the freedom of play itself.',
      errorFeedback: 'Sign B shakes both arms from the shoulder. PLAY is a wrist movement the arms stay relatively still. Full arm shaking looks like a completely different sign.',
    ),

    'Red': SignContent(
      signName: 'Red', detectionLabel: null,
      handshape: 'Index finger extended',
      placement: 'At the lips',
      movement: 'Index finger draws downward across the lips once or twice',
      facialExpression: 'Neutral, descriptive',
      thinkAboutIt: 'RED references the natural color of the lips. Many color signs in ASL have a physical or visual connection to that color. Can you spot the pattern across Red, Orange, and Yellow?',
      recognitionQuestion: 'A signer draws their index finger downward across their lips once. What color is being signed?',
      recognitionOptions: ['Blue', 'Red', 'Green', 'Orange'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'RED draws across the lips, referencing their natural red-pink color. The downward motion at the lips is the key identifier.',
      contextScenario: 'Your Deaf friend asks what color the fire engine is. The truck is a vibrant fire-engine color. You sign...',
      contextOptions: ['BLUE', 'RED', 'GREEN', 'ORANGE'],
      contextCorrectIndex: 1,
      contextExplanation: 'RED is one of the most iconic color signs. Its placement at the lips makes it instantly recognizable.',
      errorFeedback: 'Sign B draws the finger upward across the lips. RED always moves downward. The direction matters upward movement near the lips belongs to different signs.',
    ),

    'Orange': SignContent(
      signName: 'Orange', detectionLabel: null,
      handshape: 'S handshape (fist) in front of the chin',
      placement: 'In front of the chin',
      movement: 'Hand squeezes open and closed once or twice, mimicking squeezing an orange',
      facialExpression: 'Neutral, descriptive',
      thinkAboutIt: 'ORANGE mimes squeezing the fruit it is named after. Many food-based color signs in ASL have roots in the object that represents the color. How does this connect the word to its meaning?',
      recognitionQuestion: 'A signer holds a fist in front of their chin and squeezes it open and closed once. What color is this?',
      recognitionOptions: ['Red', 'Yellow', 'Orange', 'Brown'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'ORANGE the squeezing motion at the chin mimes the action of squeezing an orange fruit. The chin placement and squeezing movement together identify the sign.',
      contextScenario: 'You are describing a sunset to a Deaf friend. The sky is a warm citrus color between red and yellow. You sign...',
      contextOptions: ['RED', 'YELLOW', 'ORANGE', 'BROWN'],
      contextCorrectIndex: 2,
      contextExplanation: 'ORANGE is the natural sign here. In ASL, color vocabulary lets you describe the visual world precisely and poetically.',
      errorFeedback: 'Sign B holds the fist still without squeezing. The squeezing motion is what defines ORANGE. A stationary fist near the chin is a different sign entirely.',
    ),

    'Yellow': SignContent(
      signName: 'Yellow', detectionLabel: null,
      handshape: 'Y handshape (thumb and pinky extended)',
      placement: 'To the side of the body at shoulder level',
      movement: 'Y handshape twists or shakes back and forth at the wrist',
      facialExpression: 'Neutral, descriptive',
      thinkAboutIt: 'YELLOW initializes the color with the Y handshape and shakes it. Initialized signs use the first letter of the English word. What does this tell you about how some ASL signs were created?',
      recognitionQuestion: 'A Y handshape shakes back and forth at the wrist near the shoulder. What color is being signed?',
      recognitionOptions: ['You', 'Yellow', 'Your', 'Young'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'YELLOW uses the Y handshape shaking at the wrist. The initialized handshape is the key identifier.',
      contextScenario: 'Your Deaf friend is painting and asks which color to use for the sun. You respond...',
      contextOptions: ['ORANGE', 'WHITE', 'YELLOW', 'RED'],
      contextCorrectIndex: 2,
      contextExplanation: 'YELLOW is the natural, immediate choice for describing the sun\'s color. The Y handshake makes this sign quick and fluid in a conversation.',
      errorFeedback: 'Sign B shakes the B handshape instead of the Y handshape. YELLOW specifically requires the Y handshape with thumb and pinky extended. Changing the handshape changes the color entirely.',
    ),

    'Blue': SignContent(
      signName: 'Blue', detectionLabel: null,
      handshape: 'B handshape (four fingers together, thumb tucked)',
      placement: 'In front of the body to the side',
      movement: 'B handshape twists or shakes back and forth at the wrist',
      facialExpression: 'Neutral, descriptive',
      thinkAboutIt: 'BLUE initializes with the B handshape. Compared to YELLOW (Y) and GREEN (G), the initialized color signs form a consistent pattern. Why might ASL use the first letter of English words for some signs?',
      recognitionQuestion: 'A B handshape shakes back and forth loosely at the wrist. What color is being named?',
      recognitionOptions: ['Brown', 'Black', 'Blue', 'Big'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'BLUE the B handshake shaking at the wrist. The four fingers held together distinguish the B handshape from similar movements.',
      contextScenario: 'You are describing your favorite color to a Deaf friend. You point to the clear sky and sign...',
      contextOptions: ['GREEN', 'BLACK', 'BLUE', 'WHITE'],
      contextCorrectIndex: 2,
      contextExplanation: 'BLUE is a natural reference to the sky and sea. Using a real-world pointer like pointing to the sky before signing makes your meaning crystal clear.',
      errorFeedback: 'Sign B holds the B hand still instead of shaking it. BLUE requires movement at the wrist the shaking is not optional. A still B handshape in this context is a different sign.',
    ),

    'Green': SignContent(
      signName: 'Green', detectionLabel: null,
      handshape: 'G handshape (index finger and thumb extended, pointing forward)',
      placement: 'In front of the body',
      movement: 'G handshape shakes or twists at the wrist',
      facialExpression: 'Neutral, descriptive',
      thinkAboutIt: 'GREEN uses the G handshape shaking. Initialized signs connect to English spelling. When did ASL adopt English initialization, and what does it tell us about language contact?',
      recognitionQuestion: 'A G handshape index finger and thumb forming a point shakes at the wrist. What color is this?',
      recognitionOptions: ['Go', 'Good', 'Green', 'Grey'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'GREEN the G handshape shaking from the wrist. The specific shape of index and thumb pointing distinguishes G from other handshapes used for colors.',
      contextScenario: 'You and a Deaf friend are at the park. You want to comment on the beautiful color of the grass and trees. You sign...',
      contextOptions: ['BLUE', 'BROWN', 'RED', 'GREEN'],
      contextCorrectIndex: 3,
      contextExplanation: 'GREEN is the natural color for nature descriptions. Color signs are especially expressive in ASL because they paint vivid visual pictures.',
      errorFeedback: 'Sign B uses the full open hand shaking. GREEN specifically requires the G handshape with only the index finger and thumb active. An open hand shaking is a completely different sign.',
    ),

    'White': SignContent(
      signName: 'White', detectionLabel: null,
      handshape: 'Open 5 handshape on the chest, then fingers close to flat O',
      placement: 'On the chest',
      movement: 'Open hand placed on chest pulls away while fingers close together, as if pulling out a white shirt',
      facialExpression: 'Neutral, descriptive',
      thinkAboutIt: 'WHITE references the color of a white shirt being pulled from the chest. How does using the body as a reference point for color help create memorable signs?',
      recognitionQuestion: 'An open hand on the chest pulls away while the fingers close together. What color is being described?',
      recognitionOptions: ['Good', 'Clean', 'White', 'Happy'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'WHITE the 5 hand on the chest pulls away as fingers close, miming pulling a white shirt outward to show its color.',
      contextScenario: 'You are describing the color of fresh snow to a Deaf friend who has never seen snow. You sign...',
      contextOptions: ['GRAY', 'CLEAR', 'WHITE', 'BLUE'],
      contextCorrectIndex: 2,
      contextExplanation: 'WHITE is the most natural description for snow. Combine it with a spreading gesture to convey the vast expanse of white.',
      errorFeedback: 'Sign B pulls the open hand away from the chest without closing the fingers. The finger closure is essential to WHITE. Pulling an open hand away without closing is a different concept.',
    ),

    'Black': SignContent(
      signName: 'Black', detectionLabel: null,
      handshape: 'Index finger extended',
      placement: 'At the forehead',
      movement: 'Index finger draws sideways across the forehead from one side to the other',
      facialExpression: 'Neutral, descriptive',
      thinkAboutIt: 'BLACK draws a dark line across the forehead like a shadow or thick dark brow. How does using the forehead as a reference surface help ground this abstract color?',
      recognitionQuestion: 'An index finger draws horizontally across the forehead from one side to the other. What color is being signed?',
      recognitionOptions: ['Brown', 'Dark', 'Black', 'Bad'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'BLACK the index finger sweeps across the forehead. The forehead placement is the key feature that distinguishes BLACK from other directional index finger signs.',
      contextScenario: 'You are telling a Deaf friend about your new puppy. When they ask what color it is, you sign...',
      contextOptions: ['BROWN', 'WHITE', 'BLACK', 'ORANGE'],
      contextCorrectIndex: 2,
      contextExplanation: 'BLACK used with a pointing gesture or photo is a clear, efficient way to describe your pet\'s color.',
      errorFeedback: 'Sign B draws the finger down the cheek instead of across the forehead. BLACK is a horizontal movement across the forehead. Moving down the cheek is a completely different sign.',
    ),

    'Brown': SignContent(
      signName: 'Brown', detectionLabel: null,
      handshape: 'B handshape (four fingers together)',
      placement: 'At the cheek',
      movement: 'B handshape slides downward along the cheek once',
      facialExpression: 'Neutral, descriptive',
      thinkAboutIt: 'BROWN initializes with B and slides down the cheek, suggesting the earth-tone color. How does the combination of location and movement help you remember this sign?',
      recognitionQuestion: 'A B handshape slides straight down the side of the cheek. What color is being shown?',
      recognitionOptions: ['Bad', 'Black', 'Blue', 'Brown'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'BROWN the B handshape sliding down the cheek. Distinguishing it from BLUE (B shaking in space) relies on the cheek placement and downward movement.',
      contextScenario: 'Your Deaf friend asks the color of the soil in your garden. You sign...',
      contextOptions: ['BLACK', 'GREEN', 'RED', 'BROWN'],
      contextCorrectIndex: 3,
      contextExplanation: 'BROWN is the natural earthy response. Color signs alongside context-setting gestures make descriptions especially vivid.',
      errorFeedback: 'Sign B shakes the B hand at the cheek instead of sliding it down. BROWN is a downward sliding movement. Shaking a B hand at the cheek belongs to a different sign.',
    ),

    'Color': SignContent(
      signName: 'Color', detectionLabel: null,
      handshape: 'Open 5 handshape, fingers spread',
      placement: 'In front of the chin',
      movement: 'Fingers wiggle loosely at the chin, as if showing the spectrum of colors',
      facialExpression: 'Curious or descriptive expression',
      thinkAboutIt: 'COLOR wiggles the fingers like a rainbow spread in front of the face. How does this general waving gesture capture the idea of multiple colors all at once?',
      recognitionQuestion: 'Five spread fingers wiggle back and forth in front of the chin. What concept is being asked about?',
      recognitionOptions: ['Feeling something', 'Speaking quickly', 'Color or colors', 'Counting'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'COLOR the spread 5 hand wiggling at the chin, as if displaying many hues at once. The finger wiggling is the distinguishing motion.',
      contextScenario: 'A Deaf friend is showing you two shirts and wants you to compare them based on visual appearance. They are asking about...',
      contextOptions: ['Their size', 'Their color', 'Their price', 'Their feel'],
      contextCorrectIndex: 1,
      contextExplanation: 'COLOR is the natural question when comparing visual items. After signing COLOR, you would then sign the specific color or point to your preference.',
      errorFeedback: 'Sign B moves the whole hand back and forth rather than wiggling just the fingers. COLOR is specifically a finger-wiggling motion the wrist stays relatively still.',
    ),

    'Big': SignContent(
      signName: 'Big', detectionLabel: null,
      handshape: 'Both L handshapes (index finger and thumb extended), palms facing each other',
      placement: 'In front of the body',
      movement: 'Both L hands start close together and spread apart to indicate large size',
      facialExpression: 'Impressed or emphatic expression puffed cheeks for very large',
      thinkAboutIt: 'BIG uses both hands to show the spread of something large. The wider you spread the hands, the bigger the thing. How does this scalar use of space make ASL descriptions especially vivid?',
      recognitionQuestion: 'Both hands start close together with index fingers extended, then spread wide apart. What is being described?',
      recognitionOptions: ['A far distance', 'Something being big or large', 'Something being expensive', 'A long time'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'BIG both L hands spreading apart, showing size in space. The scale of the movement reflects the degree of size even larger spread means even bigger.',
      contextScenario: 'You want to describe to a Deaf friend that the house you visited was enormous. After signing HOUSE you add...',
      contextOptions: ['OLD', 'SMALL', 'BIG', 'BEAUTIFUL'],
      contextCorrectIndex: 2,
      contextExplanation: 'BIG with exaggerated spreading and wide eyes conveys just how large the house was. Modifying the intensity of the sign naturally expresses degrees of size.',
      errorFeedback: 'Sign B uses flat open hands instead of L handshapes. BIG specifically uses the L shape with the index and thumb to mark size. Flat hands spreading apart is a different concept.',
    ),

    'Small': SignContent(
      signName: 'Small', detectionLabel: null,
      handshape: 'Both flat hands, palms facing each other',
      placement: 'In front of the body, close together',
      movement: 'Both hands held close or moved slightly toward each other to indicate small size',
      facialExpression: 'Scrunched or compressed expression pursed lips for very small',
      thinkAboutIt: 'SMALL holds the hands close together, as if barely containing something tiny. How does the physical distance between your hands directly communicate the size of the thing being described?',
      recognitionQuestion: 'Both flat palms face each other and are held close together in front of the body. What is being described?',
      recognitionOptions: ['Nothing', 'Something being small', 'Something being quiet', 'Being uncomfortable'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'SMALL flat palms held close, showing minimal space between them. The contrast with BIG is deliberate both use two hands, but the distance is everything.',
      contextScenario: 'You are describing your new apartment to a Deaf friend. The kitchen is really quite tiny. After signing KITCHEN you add...',
      contextOptions: ['NICE', 'BIG', 'SMALL', 'OLD'],
      contextCorrectIndex: 2,
      contextExplanation: 'SMALL with a pained expression and hands nearly touching conveys the cramped feeling perfectly. ASL lets you show degree through intensity and spacing.',
      errorFeedback: 'Sign B holds only one hand flat and close to the body. SMALL requires two hands facing each other the bilateral nature of the sign is part of showing containment.',
    ),

    'More': SignContent(
      signName: 'More', detectionLabel: null,
      handshape: 'Both flat O handshapes (fingertips touching thumb)',
      placement: 'In front of the body at mid-chest height',
      movement: 'Both flat O hands tap fingertips together two or three times',
      facialExpression: 'Expectant or requesting expression',
      thinkAboutIt: 'MORE brings two hands together repeatedly, like adding one thing to another. How does this repetitive joining motion convey the idea of addition or wanting more?',
      recognitionQuestion: 'Both hands with all fingers touching the thumb tap together at the fingertips two times. What concept is this?',
      recognitionOptions: ['Finished', 'Together', 'More', 'Stop'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'MORE the flat O hands tapping together at the fingertips. The repeated tapping suggests adding, combining, or requesting additional quantity.',
      contextScenario: 'A young Deaf child is eating their favorite food and their bowl is empty. They look at you and sign...',
      contextOptions: ['FINISH', 'STOP', 'MORE', 'NO'],
      contextCorrectIndex: 2,
      contextExplanation: 'MORE is one of the first signs many children learn because it expresses a universal need efficiently. The sign is direct, clear, and easy to produce.',
      errorFeedback: 'Sign B taps the backs of the hands together instead of the fingertips. MORE requires the fingertips to touch, not the backs. The flat O shape and fingertip contact are both essential.',
    ),

    'Drink': SignContent(
      signName: 'Drink', detectionLabel: null,
      handshape: 'C handshape (curved as if holding a cup)',
      placement: 'Near the mouth',
      movement: 'C shaped hand tips upward toward the mouth, as if lifting a cup to drink',
      facialExpression: 'Natural, neutral expression',
      thinkAboutIt: 'DRINK mimes the physical act of lifting a cup to the lips. How does this iconic mime help learners from any language background recognize the sign immediately?',
      recognitionQuestion: 'A curved C shaped hand tips toward the mouth as if tilting a cup. What activity is this showing?',
      recognitionOptions: ['Eating', 'Brushing teeth', 'Drinking', 'Talking'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'DRINK the C hand mimes a cup being tipped to the lips. It is one of the most universally intuitive signs in ASL due to its direct mime of the action.',
      contextScenario: 'After a long walk on a hot day, your Deaf friend looks tired and you want to ask if they would like something to drink. You sign...',
      contextOptions: ['EAT', 'DRINK', 'SIT', 'GO'],
      contextCorrectIndex: 1,
      contextExplanation: 'DRINK as a question with raised eyebrows becomes WANT DRINK? in context. The eyebrow raise is the grammatical marker that turns it into a yes/no question.',
      errorFeedback: 'Sign B uses an open flat hand instead of a C shape. The curved C handshape mimics holding a cup it is the entire basis of the sign. An open hand tipping toward the mouth is not the same.',
    ),

    'Water': SignContent(
      signName: 'Water', detectionLabel: null,
      handshape: 'W handshape (index, middle, and ring fingers extended)',
      placement: 'At the chin',
      movement: 'W handshape taps the chin twice',
      facialExpression: 'Neutral, natural',
      thinkAboutIt: 'WATER initializes with W and taps the chin near the mouth. Tapping near the mouth for a drinkable substance makes intuitive sense. How does this location connect to the word\'s meaning?',
      recognitionQuestion: 'A W handshape with three fingers extended taps the chin twice. What is being signed?',
      recognitionOptions: ['Win', 'What', 'Water', 'Work'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'WATER the W handshape tapping the chin twice. The W initialization at the mouth and chin area connects the sign to drinking.',
      contextScenario: 'You are sitting with a Deaf friend and they look thirsty. You want to offer specifically water. You sign...',
      contextOptions: ['MILK', 'DRINK', 'WATER', 'EAT'],
      contextCorrectIndex: 2,
      contextExplanation: 'WATER specifically after WANT or with a questioning expression clarifies you are offering water not just any drink. Specificity in ASL is valued.',
      errorFeedback: 'Sign B uses only two fingers instead of three. WATER requires the W handshape with exactly three fingers extended. Two-finger tapping at the chin is a different sign entirely.',
    ),

    'Milk': SignContent(
      signName: 'Milk', detectionLabel: null,
      handshape: 'S handshape (fist)',
      placement: 'In front of the body',
      movement: 'Fist opens and closes repeatedly, mimicking the action of hand-milking a cow',
      facialExpression: 'Neutral, descriptive',
      thinkAboutIt: 'MILK mimes the motion of milking a cow by hand. Even in a modern context, the sign preserves this agricultural origin. What does this tell you about how signs can carry historical meaning?',
      recognitionQuestion: 'A signer repeatedly opens and closes their fist in a squeezing motion in front of the body. What are they signing?',
      recognitionOptions: ['Squeeze', 'Work hard', 'Milk', 'Can'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'MILK the open-close squeezing of the fist mimes milking a cow. The repeated action is the key, rather than a single squeeze which belongs to other signs.',
      contextScenario: 'A Deaf child points to their cereal bowl and signs something to ask what to pour on it. They want...',
      contextOptions: ['WATER', 'JUICE', 'MILK', 'SOUP'],
      contextCorrectIndex: 2,
      contextExplanation: 'MILK is the natural answer for a cereal context. Combined with PLEASE it becomes a polite and complete request.',
      errorFeedback: 'Sign B squeezes the fist only once and holds it. MILK requires repeated squeezing the milking motion is continuous. A single squeeze and hold is a different sign.',
    ),

    'Apple': SignContent(
      signName: 'Apple', detectionLabel: null,
      handshape: 'X handshape (bent index finger)',
      placement: 'At the cheek',
      movement: 'Bent knuckle twists against the cheek back and forth once or twice',
      facialExpression: 'Neutral, sometimes a slight smile',
      thinkAboutIt: 'APPLE twists a bent finger at the cheek like turning the stem of an apple. How do subtle physical references like this become embedded in sign language vocabulary?',
      recognitionQuestion: 'A bent index finger knuckle twists against the cheek. What food does this represent?',
      recognitionOptions: ['Candy', 'Cookie', 'Orange', 'Apple'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'APPLE the X handshape twisted at the cheek. The twisting motion distinguishes it from similar cheek-based signs like CANDY.',
      contextScenario: 'You are at the farmers market with a Deaf friend. You pick up a red piece of fruit and sign...',
      contextOptions: ['ORANGE', 'CANDY', 'APPLE', 'COOKIE'],
      contextCorrectIndex: 2,
      contextExplanation: 'APPLE after signing RED gives a complete visual description. Color plus food item creates a vivid, efficient description in ASL conversation.',
      errorFeedback: 'Sign B uses the full index finger straight against the cheek instead of the bent knuckle. APPLE requires the bent X shape the bent knuckle is the distinguishing feature.',
    ),

    'Cookie': SignContent(
      signName: 'Cookie', detectionLabel: null,
      handshape: 'Dominant curved or C shaped hand; non-dominant hand flat',
      placement: 'Non-dominant palm serves as surface; dominant hand presses and twists on it',
      movement: 'Dominant curved hand presses down and twists on the flat palm, mimicking a cookie cutter',
      facialExpression: 'Neutral to pleased expression',
      thinkAboutIt: 'COOKIE mimes using a cookie cutter on dough. Many food signs in ASL mime how the food is made or eaten. How does this connection between action and meaning make signs easier to retain?',
      recognitionQuestion: 'A curved hand presses down on an open palm and twists, like cutting circular shapes. What food is this?',
      recognitionOptions: ['Bread', 'Cake', 'Cookie', 'Pizza'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'COOKIE the cookie-cutter mime pressing and twisting on the flat palm. The twisting distinguishes it from other food signs that simply press or tap.',
      contextScenario: 'You have just baked something sweet in the oven and your Deaf friend asks what you made. You smile and sign...',
      contextOptions: ['PIZZA', 'CAKE', 'COOKIE', 'BREAD'],
      contextCorrectIndex: 2,
      contextExplanation: 'COOKIE immediately conjures the image of fresh-baked treats. The mime-based sign means you can often guess new food signs from their production.',
      errorFeedback: 'Sign B presses without twisting. The twist is what makes COOKIE different from other signs that press on the palm. Without the rotational motion, the sign is incomplete.',
    ),

    'Candy': SignContent(
      signName: 'Candy', detectionLabel: null,
      handshape: 'Index finger extended',
      placement: 'At the cheek',
      movement: 'Index finger twists against the cheek, like tucking a piece of candy into the cheek',
      facialExpression: 'Pleased, slightly indulgent expression',
      thinkAboutIt: 'CANDY references the old habit of tucking sweets into the cheek. How does this culturally specific origin still communicate the concept clearly to modern signers?',
      recognitionQuestion: 'An index finger twists against the cheek as if hiding something sweet inside. What is being signed?',
      recognitionOptions: ['Apple', 'Cute', 'Candy', 'Sick'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'CANDY the index finger twisting at the cheek. Compare with APPLE which uses the bent X knuckle. CANDY uses the straight index finger in a twisting motion.',
      contextScenario: 'You are at a birthday party and a Deaf child reaches for a sugary treat. A parent asks what the child is grabbing. The child signs...',
      contextOptions: ['COOKIE', 'APPLE', 'MILK', 'CANDY'],
      contextCorrectIndex: 3,
      contextExplanation: 'CANDY is the precise sign for sweet treats. Children often learn this sign early because the concept is highly motivating and the sign is simple to produce.',
      errorFeedback: 'Sign B uses the bent X knuckle instead of the straight index finger. That version would be APPLE, not CANDY. The straight finger versus bent knuckle distinction is the entire difference between these two signs.',
    ),

    'Hungry': SignContent(
      signName: 'Hungry', detectionLabel: null,
      handshape: 'C handshape (curved, as if holding something)',
      placement: 'Upper chest or throat area',
      movement: 'C shaped hand moves downward from the throat toward the stomach, tracing the path of hunger',
      facialExpression: 'Pained or yearning expression mouth slightly open',
      thinkAboutIt: 'HUNGRY traces the feeling of an empty stomach from the throat downward. How does this body-mapped sign physically represent the sensation of hunger rather than just naming it?',
      recognitionQuestion: 'A C shaped hand starts at the throat and slides down toward the belly. What feeling is this?',
      recognitionOptions: ['Sick', 'Thirsty', 'Hungry', 'Tired'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'HUNGRY the C hand traces from the throat to the stomach, following the path of an empty craving digestive tract. The downward path on the torso is essential.',
      contextScenario: 'It is well past lunchtime and you and your Deaf friend have not eaten. They look at you with wide eyes and sign...',
      contextOptions: ['TIRED', 'SICK', 'HUNGRY', 'SORRY'],
      contextCorrectIndex: 2,
      contextExplanation: 'HUNGRY with an exaggerated pained expression makes the feeling completely clear. The facial expression amplifies and completes the sign.',
      errorFeedback: 'Sign B moves the C hand upward from the stomach to the throat. HUNGRY always moves downward from throat toward stomach. Upward movement with this handshape conveys a different bodily experience.',
    ),

    'Pizza': SignContent(
      signName: 'Pizza', detectionLabel: null,
      handshape: 'P handshape or index and middle fingers extended',
      placement: 'In front of the body',
      movement: 'Hand traces a Z shape in the air, sometimes following a P initialization',
      facialExpression: 'Neutral to pleased expression',
      thinkAboutIt: 'PIZZA combines a P initialization with a Z trace, spelling out the last two letters of pizza. Compound or blend signs like this show how ASL bridges English and visual space. What other signs do you think might use this strategy?',
      recognitionQuestion: 'A hand traces a Z shape in the air in front of the body. What food is being signed?',
      recognitionOptions: ['Pancake', 'Pretzel', 'Pasta', 'Pizza'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'PIZZA the Z trace in front of the body, sometimes following a P shape. The Z tracing is the key identifier for this popular food sign.',
      contextScenario: 'It is Friday night and your Deaf friend suggests ordering food. They sign something that makes you think of Italy and cheese. They want...',
      contextOptions: ['SOUP', 'PIZZA', 'COOKIE', 'APPLE'],
      contextCorrectIndex: 1,
      contextExplanation: 'PIZZA is one of the most commonly signed food items in casual ASL conversation. Knowing food signs helps you navigate shared meals and social gatherings.',
      errorFeedback: 'Sign B traces an S shape instead of a Z. PIZZA ends with a Z trace the zig-zag movement of the Z is the key. An S trace or circular motion would indicate a different word.',
    ),

    'Soup': SignContent(
      signName: 'Soup', detectionLabel: null,
      handshape: 'H handshape (index and middle fingers extended together)',
      placement: 'Dominant H hand above the non-dominant flat palm',
      movement: 'H fingers scoop from the flat palm upward toward the mouth, mimicking eating soup with a spoon',
      facialExpression: 'Natural, content expression',
      thinkAboutIt: 'SOUP mimes scooping with a spoon. Using two extended fingers as a spoon and the palm as a bowl creates a mini scene in your hands. How does this kind of scene-based sign differ from EAT?',
      recognitionQuestion: 'Two extended fingers scoop from an open palm upward toward the mouth, like spooning soup. What is this?',
      recognitionOptions: ['Eat', 'Spoon', 'Soup', 'Drink'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'SOUP the H hand scoops from the open palm to the mouth, miming eating liquid food with a spoon. The bowl-and-spoon mime distinguishes SOUP from EAT or DRINK.',
      contextScenario: 'It is a cold evening and your Deaf friend makes a hot liquid meal from scratch. You sign to compliment the...',
      contextOptions: ['PIZZA', 'SOUP', 'COOKIE', 'WATER'],
      contextCorrectIndex: 1,
      contextExplanation: 'SOUP with a satisfied expression and a thumbs up communicates that the meal was delicious. Food signs in ASL conversation often pair naturally with emotional signs.',
      errorFeedback: 'Sign B uses the H fingers but moves straight to the mouth without the scooping arc. SOUP requires a clear scooping motion from the palm upward. Going directly to the mouth without the scoop looks like a different eating action.',
    ),

    'Want': SignContent(
      signName: 'Want', detectionLabel: null,
      handshape: 'Both 5 handshapes in a bent claw position, palms up',
      placement: 'In front of the body',
      movement: 'Both bent claw shaped hands pull inward toward the body, as if pulling something toward you',
      facialExpression: 'Longing or desire expression slightly forward lean',
      thinkAboutIt: 'WANT pulls both hands toward the body like physically drawing something closer to yourself. How does this inward pulling motion physically embody the concept of desire?',
      recognitionQuestion: 'Both claw shaped hands pull inward toward the signer\'s body from in front. What feeling is expressed?',
      recognitionOptions: ['Pushing away', 'Giving something', 'Wanting something', 'Finishing something'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'WANT both clawed 5 hands pulling toward the body, as if reaching for and drawing in something desired. The inward direction is essential to the meaning.',
      contextScenario: 'You are with a Deaf child in a toy store and they spot their favorite toy. They turn to you with wide eyes and sign...',
      contextOptions: ['FINISH', 'NO', 'WANT', 'STOP'],
      contextCorrectIndex: 2,
      contextExplanation: 'WANT is one of the most important and frequently used signs. Combined with pointing at the desired item, it creates a complete, meaningful sentence.',
      errorFeedback: 'Sign B uses flat open hands instead of claw shaped hands. WANT requires the bent claw position. Flat hands pulling inward is a different sign. The bent finger shape conveys the grasping nature of desire.',
    ),

    'Finish': SignContent(
      signName: 'Finish', detectionLabel: null,
      handshape: 'Both open 5 handshapes',
      placement: 'In front of the body',
      movement: 'Both hands quickly twist outward with wrists rotating so palms face out, as if releasing or dismissing something',
      facialExpression: 'Decisive, completed expression often a slight nod',
      thinkAboutIt: 'FINISH flips both hands outward as if casting something away or declaring it done. How does this releasing outward motion physically capture the sense of completion?',
      recognitionQuestion: 'Both open hands quickly flip outward from palms-in to palms-out simultaneously. What does this express?',
      recognitionOptions: ['Starting something', 'Being angry', 'Finishing or done', 'Helping'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'FINISH the quick bilateral outward flip of both 5 hands. It can mean both finished and already did, functioning as a versatile completion marker in ASL.',
      contextScenario: 'A Deaf classmate asks if you have done the homework yet. You completed it last night. You sign...',
      contextOptions: ['NO', 'WANT', 'FINISH', 'HELP'],
      contextCorrectIndex: 2,
      contextExplanation: 'FINISH as a completion marker says done, already happened. In ASL, it can function as a tense marker, placing the action in the past.',
      errorFeedback: 'Sign B flips only one hand outward. FINISH is a two-handed sign both hands flip simultaneously. One hand flipping alone changes the meaning and makes the sign grammatically incomplete.',
    ),

    'Come': SignContent(
      signName: 'Come', detectionLabel: null,
      handshape: 'Both index fingers extended',
      placement: 'In front of the body',
      movement: 'Index fingers arc from pointing away from the body toward the signer, as if beckoning',
      facialExpression: 'Inviting or beckoning expression',
      thinkAboutIt: 'COME arcs the index finger toward the signer like a beckoning gesture. This is nearly universal across cultures. Why do you think gestures of beckoning are so consistent even across different sign languages?',
      recognitionQuestion: 'Both index fingers arc from pointing outward and curve back toward the signer. What are they being asked to do?',
      recognitionOptions: ['Go', 'Stop', 'Come', 'Wait'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'COME the index fingers arc inward toward the signer, a universal beckoning motion. The direction toward the body is the defining feature.',
      contextScenario: 'You are at a Deaf gathering and spot a friend across the room. You want them to walk over to where you are standing. You sign...',
      contextOptions: ['GO', 'STOP', 'COME', 'WAIT'],
      contextCorrectIndex: 2,
      contextExplanation: 'COME is a direct and friendly invitation. In Deaf culture, catching someone\'s eye before signing is essential eye contact is required before producing the sign.',
      errorFeedback: 'Sign B arcs the fingers outward away from the body. That would mean GO. COME arcs inward toward the signer, GO arcs outward away. The direction is the entire difference between these two signs.',
    ),

    'Go': SignContent(
      signName: 'Go', detectionLabel: null,
      handshape: 'Both index fingers extended',
      placement: 'In front of the body',
      movement: 'Both index fingers arc outward away from the signer in the direction of going',
      facialExpression: 'Purposeful or directional expression can indicate urgency',
      thinkAboutIt: 'GO arcs outward in the direction of movement. By pointing index fingers in a specific direction, you can show exactly where someone is going. How does this use of space make ASL more precise than a spoken equivalent?',
      recognitionQuestion: 'Both index fingers arc forward and outward away from the signer. What direction of movement is being shown?',
      recognitionOptions: ['Coming here', 'Going away', 'Waiting', 'Stopping'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'GO both index fingers arc outward away from the body. By adjusting the direction of the arc, signers can indicate exactly where someone is going.',
      contextScenario: 'You are meeting a Deaf friend at a restaurant but need to leave early. You look at the time, then sign...',
      contextOptions: ['STAY', 'COME', 'WAIT', 'GO'],
      contextCorrectIndex: 3,
      contextExplanation: 'GO followed by pointing to the door and a sorry expression makes your early departure clear and polite. Directional verbs in ASL do a lot of heavy lifting.',
      errorFeedback: 'Sign B arcs the fingers inward toward the signer. That is COME, not GO. The outward direction away from the body is what defines GO. Reversing the arc completely changes the meaning.',
    ),

    'Walk': SignContent(
      signName: 'Walk', detectionLabel: null,
      handshape: 'Both flat hands, palms facing down',
      placement: 'In front of the body, at waist height',
      movement: 'Both hands alternate moving forward, like the flat view of feet stepping',
      facialExpression: 'Neutral, matter-of-fact',
      thinkAboutIt: 'WALK shows two hands alternating forward like feet from a bird\'s eye view. How does this top-down perspective of feet walking help you understand the relationship between viewpoint and sign formation?',
      recognitionQuestion: 'Both flat palms-down hands alternate moving forward in a stepping pattern. What physical action is this?',
      recognitionOptions: ['Clapping', 'Walking', 'Running', 'Crawling'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'WALK both hands alternating forward movement, mimicking feet from above. The alternating rhythm is what distinguishes WALK from other movement signs.',
      contextScenario: 'Your Deaf friend suggests a nearby destination and asks if you want to take a vehicle or go on foot. You prefer to go on foot, so you sign...',
      contextOptions: ['BUS', 'CAR', 'WALK', 'STAY'],
      contextCorrectIndex: 2,
      contextExplanation: 'WALK is the efficient sign for going on foot. Paired with a shrug or nod, it answers the question completely.',
      errorFeedback: 'Sign B moves both hands forward simultaneously instead of alternating. WALK requires the alternating foot-like stepping motion. Moving both at once looks like a different type of movement.',
    ),

    'Home': SignContent(
      signName: 'Home', detectionLabel: null,
      handshape: 'Flat O handshape (fingertips touching the thumb)',
      placement: 'Corner of the mouth first, then the cheek',
      movement: 'Fingertips touch the corner of the mouth, then move to touch the cheek nearby',
      facialExpression: 'Warm, comfortable expression',
      thinkAboutIt: 'HOME combines EAT (mouth) and SLEEP (cheek), the two essential things you do at home. How does this compound sign capture the concept of home through its component actions?',
      recognitionQuestion: 'Fingertips touch the corner of the mouth then move to the cheek. What place is being referenced?',
      recognitionOptions: ['School', 'Store', 'Work', 'Home'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'HOME touches the mouth (eat) then the cheek (sleep) the two core activities of home life. The two-part movement is what makes it HOME rather than either component alone.',
      contextScenario: 'After a long school day, you and your Deaf friend are parting ways. They ask where you are heading. You sign...',
      contextOptions: ['STORE', 'SCHOOL', 'HOME', 'WORK'],
      contextCorrectIndex: 2,
      contextExplanation: 'HOME is a warm, grounding word in any language. In Deaf culture, sharing where you are going is a natural part of farewell conversations.',
      errorFeedback: 'Sign B touches only the cheek without touching the mouth first. HOME requires both parts the mouth then the cheek. Skipping the mouth touch removes half of what makes this sign HOME.',
    ),

    'Store': SignContent(
      signName: 'Store', detectionLabel: null,
      handshape: 'Both bent O or flat O handshapes',
      placement: 'In front of the body',
      movement: 'Both hands swing forward at the wrists twice, as if displaying or presenting goods',
      facialExpression: 'Neutral, transactional expression',
      thinkAboutIt: 'STORE swings the hands forward like a merchant presenting wares. How does the forward-facing, outward swing suggest the display and exchange nature of a shop?',
      recognitionQuestion: 'Both bent O shaped hands swing forward at the wrists twice. What place is being described?',
      recognitionOptions: ['School', 'Home', 'Store', 'Restaurant'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'STORE the double outward swing from bent O hands, mimicking presenting goods for sale. The wrist-based forward swing is the defining motion.',
      contextScenario: 'Your Deaf friend needs to pick up groceries after school. They tell you where they are heading. They sign...',
      contextOptions: ['HOME', 'SCHOOL', 'WORK', 'STORE'],
      contextCorrectIndex: 3,
      contextExplanation: 'STORE is the natural sign for a shop or market. Combined with FOOD or GROCERY, it becomes a specific compound phrase just as in spoken language.',
      errorFeedback: 'Sign B swings the hands outward once only. STORE requires the double swing both wrists swinging forward twice. A single swing belongs to a different sign.',
    ),

    'Work': SignContent(
      signName: 'Work', detectionLabel: null,
      handshape: 'Both S handshapes (fists)',
      placement: 'In front of the body',
      movement: 'Dominant S hand taps the back of the non-dominant S hand twice',
      facialExpression: 'Focused, industrious expression',
      thinkAboutIt: 'WORK taps one fist on top of the other, like hammering or laboring. How does this stacked, rhythmic tapping convey the repetitive effort of work?',
      recognitionQuestion: 'One fist taps down on the back of the other fist twice in a steady rhythm. What concept is being signed?',
      recognitionOptions: ['Fight', 'Build', 'Work', 'Strong'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'WORK the dominant fist tapping the non-dominant. The rhythmic double tap suggests repetitive effort and labor. Both hands in S handshape is the essential starting position.',
      contextScenario: 'You want to explain to a Deaf friend why you cannot meet up on a weekday. You have responsibilities to get to. You sign...',
      contextOptions: ['SCHOOL', 'SLEEP', 'WORK', 'PLAY'],
      contextCorrectIndex: 2,
      contextExplanation: 'WORK is the straightforward explanation for weekday unavailability. Combined with a shrug or SORRY, it communicates the situation efficiently and clearly.',
      errorFeedback: 'Sign B uses flat hands instead of fists. WORK specifically requires the S handshape fists. Flat hands tapping each other is a different sign with a different meaning.',
    ),

    'Can': SignContent(
      signName: 'Can', detectionLabel: null,
      handshape: 'Both S handshapes (fists) or A handshapes',
      placement: 'In front of the body',
      movement: 'Both fists drop downward simultaneously in a single strong motion',
      facialExpression: 'Confident, assertive expression',
      thinkAboutIt: 'CAN simultaneously drops both fists downward in a decisive motion. How does this confident, firm downward movement embody the idea of ability or permission?',
      recognitionQuestion: 'Both fists drop downward at the same time in a single firm motion. What is being expressed?',
      recognitionOptions: ['Stop', 'Can or able to', 'Work', 'Fall'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'CAN both fists dropping simultaneously. The firm, decisive motion conveys capability or permission. Negated with a head shake it becomes CANNOT.',
      contextScenario: 'A Deaf student asks if you are able to help them with a problem after class. You have time, so you respond positively and sign...',
      contextOptions: ['SORRY', 'NO', 'FINISH', 'CAN'],
      contextCorrectIndex: 3,
      contextExplanation: 'CAN is an efficient response that opens the door for helping. Adding a nod reinforces the affirmative.',
      errorFeedback: 'Sign B drops one fist at a time alternately. CAN requires both fists dropping at exactly the same time simultaneously. Alternating drops looks like a completely different sign.',
    ),

    'Need': SignContent(
      signName: 'Need', detectionLabel: null,
      handshape: 'X handshape (bent or hooked index finger)',
      placement: 'In front of the body',
      movement: 'Bent index finger bends downward once or twice in a deliberate hooking motion',
      facialExpression: 'Earnest, pressing expression brows slightly furrowed',
      thinkAboutIt: 'NEED hooks downward like something pulling at you, demanding attention. How does this downward pull physically convey urgency or necessity?',
      recognitionQuestion: 'A hooked or bent index finger bends downward deliberately once or twice. What is being expressed?',
      recognitionOptions: ['Pointing at something', 'Having a question', 'Needing something', 'Hurting'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'NEED the X handshape bending downward. The hooking motion suggests something compelling you toward action. It is stronger and more urgent than WANT.',
      contextScenario: 'You are trying to communicate something important to a Deaf person and realize you do not have an interpreter. You sign the concept of urgency...',
      contextOptions: ['WANT', 'MAYBE', 'NEED', 'PLEASE'],
      contextCorrectIndex: 2,
      contextExplanation: 'NEED vs WANT is a meaningful distinction in ASL. NEED implies necessity while WANT implies desire. Getting this distinction right shows communication precision.',
      errorFeedback: 'Sign B uses the straight index finger pointing downward. NEED uses the bent X or hooked shape the bend itself is what carries the urgency. A straight pointing finger is a directional gesture, not NEED.',
    ),

    'Think': SignContent(
      signName: 'Think', detectionLabel: null,
      handshape: 'Index finger extended',
      placement: 'At the temple',
      movement: 'Index finger taps or touches the temple once',
      facialExpression: 'Contemplative, thoughtful expression gaze slightly upward',
      thinkAboutIt: 'THINK touches the temple where thinking happens. This location-based sign is intuitive even outside of ASL. Why do you think pointing to the head as a symbol of thought is so widespread across human cultures?',
      recognitionQuestion: 'An index finger taps the side of the head at the temple with a thoughtful expression. What is the signer doing?',
      recognitionOptions: ['Hearing something', 'Remembering', 'Thinking', 'Being confused'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'THINK index finger at the temple. Simple and universally intuitive, the temple location connects directly to the concept of thought.',
      contextScenario: 'A Deaf friend asks for your opinion on a difficult question. You pause and sign before answering...',
      contextOptions: ['KNOW', 'THINK', 'FINISH', 'AGAIN'],
      contextCorrectIndex: 1,
      contextExplanation: 'THINK signals that you are processing before answering. In ASL conversation, showing that you are actively engaging with a question is polite and meaningful.',
      errorFeedback: 'Sign B places the finger at the chin instead of the temple. The temple is the location for mental activity. Chin placement belongs to a different family of signs. The exact placement is everything here.',
    ),

    'Good': SignContent(
      signName: 'Good', detectionLabel: null,
      handshape: 'Flat hand, palm facing up',
      placement: 'Starts at the mouth or chin',
      movement: 'Flat hand moves forward from the chin, ending palm up as if presenting something good',
      facialExpression: 'Approving, positive expression',
      thinkAboutIt: 'GOOD moves outward from the mouth like sharing something positive. How does the forward-extending motion from the face reinforce the idea of projecting positivity toward someone else?',
      recognitionQuestion: 'A flat palm touches the chin then moves forward to present the palm upward. What is being communicated?',
      recognitionOptions: ['Thank you', 'Please', 'Good', 'Fine'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'GOOD the flat hand from chin moving forward palm up, like presenting something of value. The movement from chin outward distinguishes GOOD from THANK YOU which also starts at the chin.',
      contextScenario: 'Your Deaf friend just signed that they passed a very difficult exam. You respond with genuine enthusiasm and sign...',
      contextOptions: ['SORRY', 'FINE', 'GOOD', 'PLEASE'],
      contextCorrectIndex: 2,
      contextExplanation: 'GOOD with a big smile and nodding expresses genuine praise and approval. In Deaf culture, enthusiastic facial expressions are as important as the sign itself.',
      errorFeedback: 'Sign B starts at the chin but ends with the palm facing inward rather than upward. GOOD specifically ends with the palm facing up, like offering something. The palm orientation is the key distinguishing feature.',
    ),

    'Bad': SignContent(
      signName: 'Bad', detectionLabel: null,
      handshape: 'Flat hand, fingers together',
      placement: 'At the mouth',
      movement: 'Hand starts flat at the mouth then flips sharply downward, ending palm down, as if throwing something unpleasant away',
      facialExpression: 'Negative expression nose wrinkled, mouth turned down',
      thinkAboutIt: 'BAD starts at the mouth and flips down as if spitting something out or tossing something away. How does this rejection gesture physically match the meaning of something being bad?',
      recognitionQuestion: 'A flat hand at the mouth flips sharply downward and away, ending palm down. What judgment is being expressed?',
      recognitionOptions: ['Good', 'Stop', 'Bad', 'Finish'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'BAD the hand flips away from the mouth in disgust. The starting position at the mouth and the downward flip away are both essential to this sign.',
      contextScenario: 'You taste a piece of food that has clearly gone off. Your Deaf friend looks at you expectantly. You scrunch your face and sign...',
      contextOptions: ['GOOD', 'FINE', 'BAD', 'FINISH'],
      contextCorrectIndex: 2,
      contextExplanation: 'BAD with a disgusted facial expression creates a complete, vivid communication. In ASL, food situations are perfect contexts for emotional vocabulary.',
      errorFeedback: 'Sign B moves the hand upward from the mouth instead of downward. BAD always flips downward as if discarding something bad. Upward movement from the mouth is associated with a completely different concept.',
    ),

    'Stop': SignContent(
      signName: 'Stop', detectionLabel: null,
      handshape: 'Dominant flat hand; non-dominant flat palm faces up',
      placement: 'Non-dominant palm held still; dominant hand comes from above',
      movement: 'Dominant flat hand slices down sharply to land on the non-dominant palm',
      facialExpression: 'Firm, decisive expression direct eye contact',
      thinkAboutIt: 'STOP chops one hand down onto the other, a sudden jarring halt. How does the abruptness of the motion itself physically embody the concept of stopping something in its tracks?',
      recognitionQuestion: 'One flat hand slices sharply down to land on an outstretched palm. What command is being given?',
      recognitionOptions: ['Cut', 'Help', 'Stop', 'Finish'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'STOP the sharp chopping motion of one hand landing on the other. The abruptness of the contact mirrors the abruptness of stopping.',
      contextScenario: 'You are trying to show someone the correct sign and they keep repeating a mistake. You want them to pause before trying again. You sign...',
      contextOptions: ['AGAIN', 'FINISH', 'COME', 'STOP'],
      contextCorrectIndex: 3,
      contextExplanation: 'STOP is a clear, universal signal to pause. Followed by AGAIN, it politely creates space for correction without being rude.',
      errorFeedback: 'Sign B brings the hand down gently rather than with a sharp contact. STOP requires a decisive, firm landing the sharpness of the contact carries the meaning. A soft landing looks more like PLACE or PUT than STOP.',
    ),

    'Deaf': SignContent(
      signName: 'Deaf', detectionLabel: null,
      handshape: 'Index finger extended',
      placement: 'Near the ear, then near the corner of the mouth',
      movement: 'Index finger touches near the ear, then moves to touch near the corner of the mouth',
      facialExpression: 'Neutral, matter-of-fact expression Deaf identity is a source of cultural pride',
      thinkAboutIt: 'DEAF connects the ear and the mouth, the two points of the hearing communication system. In Deaf culture, being Deaf is an identity not a disability. How does using this sign respectfully reflect cultural awareness?',
      recognitionQuestion: 'An index finger touches near the ear, then moves to touch near the corner of the mouth. What identity or attribute is being described?',
      recognitionOptions: ['Hearing', 'Speaking', 'Deaf', 'Listening'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'DEAF the index finger connecting ear to mouth, mapping the hearing communication pathway. In Deaf culture, using this sign is a mark of respect and cultural literacy.',
      contextScenario: 'You are introducing yourself to a community group and want to explain that your friend communicates using sign language. You explain they are...',
      contextOptions: ['HEARING', 'SPEAK', 'DEAF', 'TEACHER'],
      contextCorrectIndex: 2,
      contextExplanation: 'DEAF is the respectful and culturally appropriate term within the Deaf community. In Deaf culture, Deaf with a capital D often refers to cultural identity not just audiological status.',
      errorFeedback: 'Sign B reverses the order, touching the mouth before the ear. DEAF moves from ear to mouth in that order. Reversing the direction can confuse the meaning or make the sign look like a different sign entirely.',
    ),

    'Hearing': SignContent(
      signName: 'Hearing', detectionLabel: null,
      handshape: 'Index finger extended',
      placement: 'Near the mouth',
      movement: 'Index finger makes small forward circular motions near the mouth, referencing speech and oral communication',
      facialExpression: 'Neutral, informational',
      thinkAboutIt: 'HEARING focuses on the mouth as the primary organ of vocal communication in hearing culture. What does it say about Deaf cultural perspective that HEARING is defined by its connection to speaking rather than listening?',
      recognitionQuestion: 'An index finger circles near the mouth in a small forward motion. What quality or identity is being described?',
      recognitionOptions: ['Deaf', 'Talking too much', 'Hearing', 'Learning to speak'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'HEARING the circular motion at the mouth references spoken language and vocal communication. The mouth location connects to the oral nature of hearing culture communication.',
      contextScenario: 'You are at a Deaf event and someone asks if you can hear. You can, so you sign...',
      contextOptions: ['DEAF', 'HEARING', 'FINE', 'YES'],
      contextCorrectIndex: 1,
      contextExplanation: 'HEARING is the accurate and respectful descriptor for a person who can hear. Understanding and using both DEAF and HEARING correctly shows genuine cultural awareness.',
      errorFeedback: 'Sign B places the circular motion at the ear instead of the mouth. HEARING is mouth-focused, referencing speaking not ear-focused. The mouth location is essential to distinguishing HEARING from ear-based signs.',
    ),

    'Sign': SignContent(
      signName: 'Sign', detectionLabel: null,
      handshape: 'Both index fingers extended',
      placement: 'In front of the body',
      movement: 'Both index fingers alternately circle each other in a forward rolling motion',
      facialExpression: 'Open, communicative expression',
      thinkAboutIt: 'SIGN shows two hands communicating with each other in flowing circles. How does this mutual, alternating motion capture the conversational nature of sign language as a back-and-forth exchange?',
      recognitionQuestion: 'Both index fingers alternately circle each other in a rolling forward motion. What communication modality is being described?',
      recognitionOptions: ['Writing', 'Signing or sign language', 'Dancing', 'Pointing at two things'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'SIGN the alternating circular motion of both index fingers represents the flow of signed communication. It can mean SIGN or SIGN LANGUAGE depending on context.',
      contextScenario: 'You meet a Deaf person and want to tell them you are still learning their language. You gesture to both of you and sign...',
      contextOptions: ['TALK', 'WRITE', 'SIGN', 'READ'],
      contextCorrectIndex: 2,
      contextExplanation: 'SIGN is the natural word for ASL communication. I LEARN SIGN or CAN YOU SIGN SLOWER? are common phrases for beginners. Using this word shows genuine intent to communicate.',
      errorFeedback: 'Sign B circles both fingers in the same direction simultaneously. SIGN requires alternating movement, one circle forward as the other comes back. Simultaneous circular movement has a different meaning entirely.',
    ),

    'Learn': SignContent(
      signName: 'Learn', detectionLabel: null,
      handshape: 'Dominant open hand or flat O; non-dominant hand flat palm up',
      placement: 'Dominant hand starts above the non-dominant palm, then moves to the forehead',
      movement: 'Dominant hand takes from the non-dominant palm and brings it to the forehead, like depositing knowledge',
      facialExpression: 'Open, receptive expression',
      thinkAboutIt: 'LEARN picks up knowledge from a surface like a book and deposits it into the head. This physical metaphor of knowledge as something tangible that can be picked up and placed in the mind shows ASL\'s spatial approach to abstract concepts. How does this differ from how spoken languages describe learning?',
      recognitionQuestion: 'One hand takes something from the other open palm and brings it up to the forehead. What activity is this?',
      recognitionOptions: ['Remembering', 'Teaching', 'Learning', 'Reading'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'LEARN the hand picks from the palm and deposits at the forehead, literally moving knowledge from a source into the mind. It is the reverse direction of TEACH which moves from the forehead outward.',
      contextScenario: 'You want to tell a Deaf person why you are taking sign language classes. You explain...',
      contextOptions: ['TEACH', 'FINISH', 'LEARN', 'THINK'],
      contextCorrectIndex: 2,
      contextExplanation: 'LEARN followed by SIGN LANGUAGE creates a complete explanation. I LEARN SIGN is immediately understood and appreciated by Deaf signers.',
      errorFeedback: 'Sign B brings the hand from the forehead down to the palm. That direction would mean TEACH, not LEARN. Knowledge moves from the source to the head for LEARN, and from the head outward for TEACH.',
    ),

    'Again': SignContent(
      signName: 'Again', detectionLabel: null,
      handshape: 'Dominant bent hand or B handshape bent at knuckles',
      placement: 'Non-dominant hand held flat, palm up',
      movement: 'Dominant bent hand arcs and flips to land on the non-dominant palm with a tap',
      facialExpression: 'Expectant or requesting expression',
      thinkAboutIt: 'AGAIN is one of the most useful signs for learners. The arc-and-land motion is like resetting something to the beginning. How does this physical reset motion connect to the concept of doing something over?',
      recognitionQuestion: 'A bent hand arcs and lands with a tap on the flat open palm beneath it. What is being requested?',
      recognitionOptions: ['Stop', 'Again or one more time', 'Finish', 'Help'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'AGAIN the arc and tap onto the flat palm. The resetting arc motion captures the idea of returning to the start and doing something over.',
      contextScenario: 'A Deaf person signs something too quickly for you to follow. You make a polite expression and sign...',
      contextOptions: ['STOP', 'SORRY then AGAIN', 'FINISH', 'NO'],
      contextCorrectIndex: 1,
      contextExplanation: 'SORRY + AGAIN is the polite, respectful formula for asking someone to repeat. In Deaf culture, asking for repetition is normal and expected it is not rude to ask for clarification.',
      errorFeedback: 'Sign B taps the back of the non-dominant hand instead of the palm. AGAIN lands on the open palm, not the back of the hand. The palm-up receiving surface is the correct target.',
    ),

    'Meet': SignContent(
      signName: 'Meet', detectionLabel: null,
      handshape: 'Both index fingers extended, one on each hand',
      placement: 'In front of the body, starting apart',
      movement: 'Both index fingers start at a distance from each other then come together to meet in the middle',
      facialExpression: 'Warm, open expression often paired with a smile',
      thinkAboutIt: 'MEET shows two people represented by the index fingers moving toward each other until they connect. What does this visual representation of two paths converging say about the concept of meeting someone?',
      recognitionQuestion: 'Two index fingers start apart and move toward each other until they meet and touch in the middle. What activity is this?',
      recognitionOptions: ['Fight', 'Separate', 'Meet', 'Stop'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'MEET both index fingers representing two people moving together until they connect. The coming-together motion is the entire meaning of the sign.',
      contextScenario: 'After a long time of communicating only online, you and a Deaf pen pal are about to see each other for the first time. You are excited to...',
      contextOptions: ['LEARN', 'GOODBYE', 'MEET', 'SIGN'],
      contextCorrectIndex: 2,
      contextExplanation: 'MEET is a powerful, emotionally warm sign in context. NICE MEET YOU is one of the most common phrases in ASL introductions, and it carries genuine warmth.',
      errorFeedback: 'Sign B uses both index fingers moving in the same direction rather than toward each other. MEET requires the fingers to come from opposite sides toward the center. Same-direction movement suggests following or accompanying, not meeting.',
    ),
  };
}

// ── GIF asset map (keyed by sign name) ─────────────────────────────────────

class SignGifMap {
  static String? gif(String signName) => _gifs[signName];

  static const Map<String, String> _gifs = {
    'Hello':  'assets/gifs/hello.gif',
    'Mother': 'assets/gifs/mother.gif',
    'Father': 'assets/gifs/father.gif',
    'Sister': 'assets/gifs/sister.gif',
    // Add more as GIFs are produced
  };
}

// ── Video asset map (keyed by sign name) ─────────────────────────────────────

class LessonVideoMap {
  /// Correct demonstration video for a sign, or null if not available.
  static String? correctVideo(String signName) => _correctVideos[signName];

  /// Incorrect demonstration video for a sign, or null if not available.
  static String? incorrectVideo(String signName) => _incorrectVideos[signName];

  /// Legacy lesson-level lookup (kept for compatibility).
  static String? correctVideoForLesson(String lessonId) {
    // Return the first sign's video for this lesson
    final lesson = LessonUnit.findLesson(lessonId);
    if (lesson == null || lesson.signs.isEmpty) return null;
    return correctVideo(lesson.signs.first);
  }

  static String? incorrectVideoForLesson(String lessonId) {
    final lesson = LessonUnit.findLesson(lessonId);
    if (lesson == null || lesson.signs.isEmpty) return null;
    return incorrectVideo(lesson.signs.first);
  }

  static const Map<String, String> _correctVideos = {
    'Hello':  'assets/videos/u1l1_hello_correct.mp4',
    'Mother': 'assets/videos/u4l1_mother_correct.mp4',
    'Father': 'assets/videos/u4l1_father_correct.mp4',
    'Sister': 'assets/videos/u4l1_sister_correct.mp4',
    // Add more as videos are produced
  };

  static const Map<String, String> _incorrectVideos = {
    'Hello':  'assets/videos/u1l1_hello_incorrect.mp4',
    'Mother': 'assets/videos/u4l1_mother_incorrect.mp4',
    'Father': 'assets/videos/u4l1_father_incorrect.mp4',
    'Sister': 'assets/videos/u4l1_sister_incorrect.mp4',
    // Add more as videos are produced
  };
}

// ── Supporting data ─────────────────────────────────────────────────────────

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

  const CultureNote({required this.title, required this.description, required this.icon});

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
    VocabularyItem(sign: 'Hello', meaning: 'A greeting used when meeting someone', category: 'Greetings',
        handshape: 'Open hand, fingers together', movement: 'Hand moves away from forehead in a salute like motion',
        placement: 'Starts near the forehead', commonMistake: 'Moving the hand too far from the face',
        exampleContext: 'Use when greeting a friend or meeting someone new'),
    VocabularyItem(sign: 'Thank You', meaning: 'Expression of gratitude', category: 'Everyday',
        handshape: 'Flat hand, palm facing you', movement: 'Hand moves forward from chin',
        placement: 'Starts at the chin', commonMistake: 'Starting too low should begin at chin level',
        exampleContext: 'After receiving help or a gift'),
    VocabularyItem(sign: 'Please', meaning: 'Polite request word', category: 'Everyday',
        handshape: 'Flat hand on chest', movement: 'Circular motion on the chest',
        placement: 'Center of chest', commonMistake: 'Making the circle too small',
        exampleContext: 'When asking someone for something politely'),
    VocabularyItem(sign: 'Sorry', meaning: 'Expression of apology', category: 'Everyday',
        handshape: 'Fist with thumb extended (A handshape)', movement: 'Circular motion on chest',
        placement: 'Center of chest', commonMistake: 'Confusing with PLEASE Sorry uses a fist, Please uses flat hand',
        exampleContext: 'When apologizing for a mistake'),
    VocabularyItem(sign: 'Yes', meaning: 'Affirmative response', category: 'Everyday',
        handshape: 'S handshape (fist)', movement: 'Nod the fist up and down',
        placement: 'In front of the body', commonMistake: 'Moving the whole arm instead of just the wrist',
        exampleContext: 'Answering a yes/no question'),
    VocabularyItem(sign: 'No', meaning: 'Negative response', category: 'Everyday',
        handshape: 'Index and middle finger extended', movement: 'Snap fingers together with thumb',
        placement: 'In front of the body', commonMistake: 'Using only the index finger',
        exampleContext: 'Declining an offer or answering negatively'),
    VocabularyItem(sign: 'Teacher', meaning: 'A person who instructs others', category: 'School',
        handshape: 'Both hands in flat O shape near temples', movement: 'Move hands outward, then add PERSON marker',
        placement: 'Near the temples', commonMistake: 'Forgetting the PERSON marker at the end',
        exampleContext: 'Referring to your instructor in class'),
    VocabularyItem(sign: 'Mother', meaning: 'Female parent', category: 'Family',
        handshape: 'Open hand, thumb touching chin', movement: 'Thumb taps chin',
        placement: 'At the chin', commonMistake: 'Touching the forehead instead of chin (that means Father)',
        exampleContext: 'Talking about your family'),
    VocabularyItem(sign: 'Father', meaning: 'Male parent', category: 'Family',
        handshape: 'Open hand, thumb touching forehead', movement: 'Thumb taps forehead',
        placement: 'At the forehead', commonMistake: 'Touching the chin instead of forehead (that means Mother)',
        exampleContext: 'Talking about your family'),
    VocabularyItem(sign: 'Friend', meaning: 'A person you have a bond with', category: 'Relationships',
        handshape: 'Index fingers hooked together', movement: 'Hook and switch positions',
        placement: 'In front of the body', commonMistake: 'Not switching the hook direction',
        exampleContext: 'Introducing someone as your friend'),
  ];


  /// Build a VocabularyItem from a SignContent entry.
  factory VocabularyItem.fromSignContent(SignContent sc) {
    // Derive category from which unit/lesson the sign belongs to
    String category = 'General';
    for (final unit in LessonUnit.sampleUnits) {
      for (final lesson in unit.lessons) {
        if (lesson.signs.contains(sc.signName)) {
          category = unit.title;
          break;
        }
      }
    }
    return VocabularyItem(
      sign: sc.signName,
      meaning: sc.contextScenario.length > 60
          ? sc.contextScenario.substring(0, 57) + '...'
          : sc.contextScenario,
      category: category,
      handshape: sc.handshape,
      movement: sc.movement,
      placement: sc.placement,
      commonMistake: sc.errorFeedback.length > 80
          ? sc.errorFeedback.substring(0, 77) + '...'
          : sc.errorFeedback,
      exampleContext: sc.contextExplanation,
    );
  }

  /// All 38 signs from the curriculum as VocabularyItems.
  static List<VocabularyItem> get allItems {
    return SignContent.allSigns
        .map((sc) => VocabularyItem.fromSignContent(sc))
        .toList();
  }

  /// Categories derived from all items.
  static List<String> get allCategories =>
      allItems.map((e) => e.category).toSet().toList()..sort();

  static List<String> get categories =>
      sampleItems.map((e) => e.category).toSet().toList();
}