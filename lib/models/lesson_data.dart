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
        UnitLesson(id: 'u1l4', title: 'How Are You?', duration: '10 min', signs: ['How', 'Please', 'Fine']),
        UnitLesson(id: 'u1l5', title: 'Introducing Others', duration: '12 min', signs: ['Friend', 'Hello', 'This Is']),
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
        learningGoal: 'Ask and respond to HOW ARE YOU using PLEASE and common replies.'),
    'u1l5': LessonContent(lessonId: 'u1l5', estimatedTime: '12 min',
        learningGoal: 'Introduce a third person to a Deaf friend using HELLO, THIS, and FRIEND.'),
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

  /// YOLO model label — null if the model cannot detect this sign.
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

  static const Map<String, SignContent> _all = {

    'Hello': SignContent(
      signName: 'Hello', detectionLabel: 'Hello',
      handshape: 'Open hand, fingers together',
      placement: 'Near the forehead',
      movement: 'Hand moves away from forehead in a smooth salute',
      facialExpression: 'Friendly — eyebrows slightly raised',
      thinkAboutIt: 'The motion mirrors a casual salute — starting near the forehead and moving outward. Why do you think greetings in many cultures involve the hand near the head?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Goodbye', 'Hello', 'Thank You', 'Please'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'HELLO — the open hand moves away from the forehead in a salute-like motion. Think of it as a friendly military salute.',
      contextScenario: 'You walk into a room and see a Deaf friend. What do you sign first?',
      contextOptions: ['PLEASE', 'SORRY', 'HELLO', 'THANK YOU'],
      contextCorrectIndex: 2,
      contextExplanation: 'HELLO always opens an interaction. Making eye contact first, then signing HELLO, is culturally appropriate.',
      errorFeedback: 'Sign B snaps away too quickly from the forehead. HELLO should be a smooth, relaxed salute motion — not a sharp flick.',
    ),

    'Goodbye': SignContent(
      signName: 'Goodbye', detectionLabel: null,
      handshape: 'Open hand, all fingers extended',
      placement: 'In front of the face at shoulder height',
      movement: 'Fingers bend down and up repeatedly, or hand waves side to side',
      facialExpression: 'Warm, departing smile',
      thinkAboutIt: 'GOODBYE visually waves farewell. How does mimicking a natural wave help make this sign immediately understandable?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Hello', 'Please', 'Goodbye', 'Thank You'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'GOODBYE — the open hand waves, fingers bending or the hand waving side to side. It is one of the most universally understood gestures.',
      contextScenario: 'You are leaving your Deaf friend\'s house after a visit. What is the last sign you use?',
      contextOptions: ['HELLO', 'SORRY', 'PLEASE', 'GOODBYE'],
      contextCorrectIndex: 3,
      contextExplanation: 'GOODBYE is the natural closing sign for any interaction. Maintaining eye contact while signing shows warmth and respect.',
      errorFeedback: 'Sign B uses only two fingers instead of the full open hand. GOODBYE uses all fingers extended in an open wave.',
    ),

    'Name': SignContent(
      signName: 'Name', detectionLabel: null,
      handshape: 'Both hands in H handshape — index and middle fingers extended together',
      placement: 'In front of the body at mid-chest',
      movement: 'Dominant H fingers tap on top of non-dominant H fingers twice',
      facialExpression: 'Neutral, attentive expression',
      thinkAboutIt: 'NAME uses two H handshapes tapping together. What do you think helps people remember this sign — the shape, the movement, or both?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Hello', 'Friend', 'Name', 'Class'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'NAME — both hands in H handshape (index and middle fingers), dominant tapping on non-dominant twice.',
      contextScenario: 'You want to ask a new Deaf acquaintance what they are called. You sign...',
      contextOptions: ['WHAT TEACHER', 'YOUR NAME', 'PLEASE HELP', 'THANK YOU'],
      contextCorrectIndex: 1,
      contextExplanation: 'YOUR NAME (pointing to the person, then NAME) is the standard way to ask someone\'s name in ASL.',
      errorFeedback: 'Sign B uses only the index finger — that is the G or 1 handshape. NAME requires both the index AND middle finger together (H handshape).',
    ),

    'Nice': SignContent(
      signName: 'Nice', detectionLabel: null,
      handshape: 'Both hands flat, palms facing up',
      placement: 'Non-dominant hand stays still in front of body; dominant hand above it',
      movement: 'Dominant flat hand slides forward across the non-dominant palm',
      facialExpression: 'Pleased, warm expression',
      thinkAboutIt: 'NICE looks like you are smoothing something out — making it "nice." How does the sliding motion physically reflect the idea of something being pleasant?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Sorry', 'Thank You', 'Please', 'Nice'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'NICE — the dominant hand slides forward across the non-dominant palm, like smoothing a surface clean.',
      contextScenario: 'After being introduced to someone, you want to say it was a pleasure. You sign...',
      contextOptions: ['SORRY', 'PLEASE', 'NICE MEET YOU', 'THANK YOU'],
      contextCorrectIndex: 2,
      contextExplanation: 'NICE comes first in NICE MEET YOU — it describes the quality of the meeting before you name the action (MEET) and the person (YOU).',
      errorFeedback: 'Sign B moves the hand backward instead of forward. NICE always slides in the forward direction away from the body.',
    ),

    'Thank You': SignContent(
      signName: 'Thank You', detectionLabel: 'Thank You',
      handshape: 'Flat hand, palm facing you',
      placement: 'Starts at the chin',
      movement: 'Hand moves forward away from the chin',
      facialExpression: 'Grateful, warm expression',
      thinkAboutIt: 'THANK YOU moves from your chin outward — as if directing your gratitude toward the other person. How does that directionality reinforce the meaning?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Please', 'Hello', 'Sorry', 'Thank You'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'THANK YOU — flat hand at the chin moves forward, projecting gratitude outward toward the other person.',
      contextScenario: 'Someone held a door open for you. What do you sign?',
      contextOptions: ['SORRY', 'PLEASE', 'HELLO', 'THANK YOU'],
      contextCorrectIndex: 3,
      contextExplanation: 'THANK YOU is the natural response to any act of kindness. A genuine facial expression makes it more sincere.',
      errorFeedback: 'Sign B starts too low near the collar. THANK YOU must begin at chin level — the starting position is part of the sign.',
    ),

    'How': SignContent(
      signName: 'How', detectionLabel: null,
      handshape: 'Both hands in curved/bent shape, knuckles touching',
      placement: 'In front of the body',
      movement: 'Hands rotate forward and apart, ending palms up',
      facialExpression: 'Raised eyebrows — this is a question word and requires facial grammar',
      thinkAboutIt: 'HOW involves both hands rotating open. In ASL, open palms often signal a question or openness. How does this connect to asking "how"?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['What', 'When', 'How', 'Where'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'HOW — both curved hands with knuckles touching rotate forward and open outward, palms ending face up.',
      contextScenario: 'You want to ask a Deaf friend how their day was. You sign...',
      contextOptions: ['WHAT DAY', 'WHERE GO', 'HOW YOU', 'PLEASE HELP'],
      contextCorrectIndex: 2,
      contextExplanation: 'HOW + YOU (or HOW + YOUR + DAY) is a natural, warm way to check in. The raised eyebrows signal it is a question.',
      errorFeedback: 'Sign B ends with palms facing down instead of up. The upward palm finish is essential to HOW.',
    ),

    'Please': SignContent(
      signName: 'Please', detectionLabel: 'Please',
      handshape: 'Flat hand pressed against the chest',
      placement: 'Center of the chest',
      movement: 'Smooth circular motion on the chest',
      facialExpression: 'Polite, warm expression',
      thinkAboutIt: 'PLEASE sits at the chest — the center of polite, heartfelt communication. How does placing this sign at the heart reinforce the idea of asking sincerely?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Sorry', 'Thank You', 'Please', 'Yes'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'PLEASE — flat hand circles on the chest. A fist in the same position means SORRY, so the handshape is the key difference.',
      contextScenario: 'You want to borrow a classmate\'s pen. What do you sign first?',
      contextOptions: ['THANK YOU', 'HELLO', 'PLEASE', 'SORRY'],
      contextCorrectIndex: 2,
      contextExplanation: 'PLEASE comes before your request — just as in spoken language. It signals you are asking politely, not demanding.',
      errorFeedback: 'Sign B uses a fist instead of a flat hand — that makes it SORRY. The open flat hand is what makes this PLEASE.',
    ),

    'Fine': SignContent(
      signName: 'Fine', detectionLabel: null,
      handshape: 'Open hand, thumb extended, other fingers spread',
      placement: 'At the chest',
      movement: 'Thumb taps the chest once',
      facialExpression: 'Content, neutral to positive expression',
      thinkAboutIt: 'FINE uses the thumb touching the chest — a self-referential, affirming gesture. How is this different from just nodding?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Happy', 'Thank You', 'Please', 'Fine'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'FINE — the open hand with thumb extended taps the chest once, meaning "I\'m good / I\'m fine."',
      contextScenario: 'Someone asks HOW ARE YOU. You are doing well. You sign...',
      contextOptions: ['SORRY', 'PLEASE', 'THANK YOU', 'FINE'],
      contextCorrectIndex: 3,
      contextExplanation: 'FINE is a common, neutral positive response to HOW ARE YOU. You can also sign GOOD or GREAT depending on how you feel.',
      errorFeedback: 'Sign B taps the chin instead of the chest. FINE sits at the chest — the chin location belongs to other signs entirely.',
    ),

    'Friend': SignContent(
      signName: 'Friend', detectionLabel: 'Friend',
      handshape: 'Index fingers hooked together',
      placement: 'In front of the body',
      movement: 'Hook the index fingers together, then flip and switch which is on top',
      facialExpression: 'Warm, open expression',
      thinkAboutIt: 'FRIEND involves two fingers linking and switching — representing a reciprocal bond. What does the switching motion say about the nature of friendship?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Teacher', 'Sorry', 'Please', 'Friend'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'FRIEND — index fingers hook together and switch, representing the mutual bond between two people.',
      contextScenario: 'You want to introduce someone you care about to a Deaf classmate. You sign...',
      contextOptions: ['SORRY + wave', 'TEACHER + NAME', 'MY FRIEND + NAME', 'PLEASE + HELLO'],
      contextCorrectIndex: 2,
      contextExplanation: 'MY FRIEND + NAME is the clear, warm way to introduce someone. Signing FRIEND first establishes the relationship.',
      errorFeedback: 'Sign B hooks the fingers but does not switch — only going one direction. The switch is essential; without it FRIEND is incomplete.',
    ),

    'This Is': SignContent(
      signName: 'This Is', detectionLabel: null,
      handshape: 'Index finger extended (pointing gesture)',
      placement: 'Directed toward the person or thing being indicated',
      movement: 'Point the index finger toward the referent, then sign their name or role',
      facialExpression: 'Open, inclusive — looking between both people when introducing',
      thinkAboutIt: 'Pointing in ASL is a pronoun — THIS/HE/SHE/IT depending on context. How is pointing in sign language more direct than using a spoken pronoun?',
      recognitionQuestion: 'What does this sign mean in context?',
      recognitionOptions: ['Please', 'Friend', 'This/Here', 'Teacher'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'THIS — pointing the index finger toward someone or something establishes it as the topic of the sentence.',
      contextScenario: 'You are introducing your friend to someone. After signing HELLO, you...',
      contextOptions: ['Sign SORRY', 'Wave at both', 'Point + sign FRIEND', 'Sign GOODBYE'],
      contextCorrectIndex: 2,
      contextExplanation: 'Pointing establishes the referent before signing their relationship. This is normal ASL grammar — point first, then describe.',
      errorFeedback: 'Sign B uses the whole hand instead of just the index finger. Pointing in ASL always uses the index finger only.',
    ),

    'Yes': SignContent(
      signName: 'Yes', detectionLabel: 'Yes',
      handshape: 'S handshape — closed fist',
      placement: 'In front of the body',
      movement: 'Fist nods up and down from the wrist',
      facialExpression: 'Affirming — slight nod of the head alongside the sign',
      thinkAboutIt: 'YES is a fist that nods — physically mimicking a head nod. How does this physical echo between hand and head reinforce the sign\'s meaning?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['No', 'Maybe', 'Sorry', 'Yes'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'YES — the closed fist nods up and down from the wrist, mirroring the head nod for affirmation.',
      contextScenario: 'A Deaf friend asks if you want to join them for lunch. You happily agree. You sign...',
      contextOptions: ['Wave your hand', 'THANK YOU only', 'PLEASE', 'YES'],
      contextCorrectIndex: 3,
      contextExplanation: 'YES is direct and unambiguous. You can pair it with a smile and nod for extra expressiveness.',
      errorFeedback: 'Sign B moves the whole arm up and down. YES should be a small wrist nod only — not a full arm movement.',
    ),

    'No': SignContent(
      signName: 'No', detectionLabel: 'No',
      handshape: 'Index and middle fingers extended, thumb extended',
      placement: 'In front of the body',
      movement: 'Index and middle fingers snap down to meet the thumb',
      facialExpression: 'Slight head shake — facial grammar reinforces NO',
      thinkAboutIt: 'NO snaps the fingers together — like closing off a possibility. How does the snapping motion physically represent saying no?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Yes', 'Maybe', 'Please', 'No'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'NO — index and middle fingers snap down to the thumb, often with a slight head shake for emphasis.',
      contextScenario: 'Someone offers you something you do not want. What do you sign?',
      contextOptions: ['SORRY', 'PLEASE', 'YES', 'NO'],
      contextCorrectIndex: 3,
      contextExplanation: 'NO paired with a slight head shake is clear and unmistakable. The combination of hand sign and facial grammar makes the meaning immediate.',
      errorFeedback: 'Sign B uses only one finger snapping down. NO requires both the index AND middle finger together snapping to the thumb.',
    ),

    'Maybe': SignContent(
      signName: 'Maybe', detectionLabel: null,
      handshape: 'Both open hands, palms facing up',
      placement: 'In front of the body',
      movement: 'Hands alternate up and down, like two sides of a scale weighing options',
      facialExpression: 'Uncertain — slightly pursed lips or raised brows',
      thinkAboutIt: 'MAYBE looks like two scales balancing — weighing two possibilities. How does the alternating motion physically mirror the idea of uncertainty?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Yes', 'No', 'Help', 'Maybe'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'MAYBE — both open palms alternate up and down, as if weighing two options against each other.',
      contextScenario: 'A Deaf friend asks if you can attend an event. You are not sure yet. You sign...',
      contextOptions: ['YES', 'NO', 'SORRY', 'MAYBE'],
      contextCorrectIndex: 3,
      contextExplanation: 'MAYBE is honest and appropriate when you are uncertain. You can follow it with DEPENDS or LATER to give more context.',
      errorFeedback: 'Sign B moves both hands in the same direction simultaneously. MAYBE requires alternating — one hand up while the other is down.',
    ),

    'Help': SignContent(
      signName: 'Help', detectionLabel: null,
      handshape: 'Dominant A handshape (fist, thumb up) resting on open non-dominant palm',
      placement: 'In front of the body at waist level',
      movement: 'Both hands rise upward together',
      facialExpression: 'Eyebrows raised — asking expression',
      thinkAboutIt: 'HELP looks like one hand lifting another up. How does that visual metaphor of lifting connect to what helping someone actually means?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Please', 'Sorry', 'Help', 'Thank You'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'HELP — the A handshape rests on the open palm and both rise together, as if one hand is lifting the other.',
      contextScenario: 'A Deaf person signs something you did not understand. You sign...',
      contextOptions: ['Just shrug', 'Shake your head', 'SORRY + HELP + AGAIN', 'Walk away'],
      contextCorrectIndex: 2,
      contextExplanation: 'SORRY + HELP + AGAIN is the respectful response — you acknowledge the gap and ask for assistance to understand.',
      errorFeedback: 'Sign B uses only one hand — just the thumbs-up fist without the supporting palm. HELP requires both hands working together.',
    ),

    'Sorry': SignContent(
      signName: 'Sorry', detectionLabel: 'Sorry',
      handshape: 'A handshape — closed fist',
      placement: 'Center of the chest',
      movement: 'Circular motion on the chest',
      facialExpression: 'Regretful — slight downward gaze, brow slightly furrowed',
      thinkAboutIt: 'SORRY and PLEASE both circle on the chest. The fist versus flat hand is the only difference. Why do you think this small distinction carries such significant meaning?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Happy', 'Please', 'Thank You', 'Sorry'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'SORRY — the fist rotates on the chest. The fist distinguishes it from PLEASE, which uses a flat hand in the same position.',
      contextScenario: 'You accidentally bump into a Deaf person. What do you sign immediately?',
      contextOptions: ['Wave it off', 'THANK YOU', 'PLEASE', 'SORRY'],
      contextCorrectIndex: 3,
      contextExplanation: 'SORRY paired with a genuine regretful expression is both polite and culturally appropriate. Facial expression carries half the meaning.',
      errorFeedback: 'Sign B uses a flat hand — that makes it PLEASE. The difference between SORRY (fist) and PLEASE (flat hand) is essential.',
    ),

    'Happy': SignContent(
      signName: 'Happy', detectionLabel: null,
      handshape: 'Open flat hand, palm facing you',
      placement: 'At the chest',
      movement: 'Hand brushes upward on the chest in a circular motion, repeated',
      facialExpression: 'Genuine smile — the facial expression is essential here',
      thinkAboutIt: 'HAPPY brushes upward — as if lifting your heart. How does the upward direction communicate a positive emotional state?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Sorry', 'Sad', 'Please', 'Happy'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'HAPPY — the open hand brushes upward on the chest, often repeated, always paired with a genuine smile.',
      contextScenario: 'You just got great news and your Deaf friend asks how you feel. You sign...',
      contextOptions: ['SORRY', 'SAD', 'PLEASE', 'HAPPY'],
      contextCorrectIndex: 3,
      contextExplanation: 'HAPPY is most expressive when the facial expression matches — a big smile while signing makes the emotion fully clear.',
      errorFeedback: 'Sign B brushes downward instead of upward. The upward motion is what communicates the uplift of happiness.',
    ),

    'Sad': SignContent(
      signName: 'Sad', detectionLabel: null,
      handshape: 'Both open hands, fingers spread, palms facing you',
      placement: 'In front of the face',
      movement: 'Hands move downward in front of the face',
      facialExpression: 'Downturned mouth, drooping expression — the face carries most of the meaning',
      thinkAboutIt: 'SAD drags hands downward in front of the face — like a falling expression. How does gravity and downward motion relate to negative emotions?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Happy', 'Sorry', 'Please', 'Sad'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'SAD — both hands drop downward in front of the face, reflecting a fallen or downcast expression.',
      contextScenario: 'You receive bad news and a Deaf friend asks how you feel. You sign...',
      contextOptions: ['HAPPY', 'SORRY', 'PLEASE', 'SAD'],
      contextCorrectIndex: 3,
      contextExplanation: 'SAD is one of the most expressive signs — your face must reflect sadness. Without the downcast expression, the sign loses its impact.',
      errorFeedback: 'Sign B uses only one hand. SAD is a two-handed sign — both hands drop simultaneously in front of the face.',
    ),

    'Book': SignContent(
      signName: 'Book', detectionLabel: null,
      handshape: 'Both hands flat, palms pressed together',
      placement: 'In front of the body at chest height',
      movement: 'Open hands outward like opening a book',
      facialExpression: 'Neutral, focused',
      thinkAboutIt: 'BOOK mimics the physical act of opening a book. Many object signs in ASL mime how the object is used. What other everyday objects might have signs that work this way?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Pencil', 'Paper', 'Book', 'Chair'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'BOOK — both palms pressed together open outward, exactly like opening a physical book.',
      contextScenario: 'The teacher tells you to take out your reading material. You reach for your...',
      contextOptions: ['Pencil', 'Paper', 'Book', 'Chair'],
      contextCorrectIndex: 2,
      contextExplanation: 'BOOK is the clear, natural sign here. Using mimed object signs in context makes them easy to remember.',
      errorFeedback: 'Sign B opens the hands upward instead of outward. BOOK opens to the sides — like a real book — not upward.',
    ),

    'Pencil': SignContent(
      signName: 'Pencil', detectionLabel: null,
      handshape: 'Dominant hand mimics holding a pencil tip near the mouth, then writing',
      placement: 'Near the mouth first, then moves to write on the non-dominant palm',
      movement: 'Mime licking a pencil tip near the mouth, then make a writing motion on the other palm',
      facialExpression: 'Neutral, casual',
      thinkAboutIt: 'PENCIL mimes the old habit of licking a pencil tip before writing. Even if you do not do this, why does the mime make the sign recognizable?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Book', 'Paper', 'Write', 'Pencil'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'PENCIL — mime licking a pencil near the mouth, then make a writing motion on the non-dominant palm.',
      contextScenario: 'You want to take notes in class and need a writing tool. You sign...',
      contextOptions: ['BOOK', 'PAPER', 'PENCIL', 'WRITE'],
      contextCorrectIndex: 2,
      contextExplanation: 'PENCIL specifically means a pencil. If you wanted a pen, a different sign is used — specificity matters in sign language.',
      errorFeedback: 'Sign B skips the mouth part and goes straight to writing. The lick motion near the mouth is what distinguishes PENCIL from WRITE.',
    ),

    'Paper': SignContent(
      signName: 'Paper', detectionLabel: null,
      handshape: 'Both hands flat, palms down',
      placement: 'Non-dominant hand stays still; dominant hand moves across it',
      movement: 'Dominant hand brushes sideways across the non-dominant palm twice',
      facialExpression: 'Neutral',
      thinkAboutIt: 'PAPER looks like smoothing out a flat sheet. How does the flat, horizontal brushing motion relate to what paper looks and feels like?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Book', 'Pencil', 'Paper', 'Write'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'PAPER — dominant hand brushes across the non-dominant palm, mimicking smoothing a flat sheet.',
      contextScenario: 'Your teacher asks you to hand in your worksheet. What object do you pick up?',
      contextOptions: ['Book', 'Pencil', 'Paper', 'Chair'],
      contextCorrectIndex: 2,
      contextExplanation: 'PAPER is for any flat sheet — homework, worksheets, documents. The flat, brushing motion is visually intuitive.',
      errorFeedback: 'Sign B moves the hand in a circular motion instead of a straight sideways brush. PAPER is a directional motion, not circular.',
    ),

    'Teacher': SignContent(
      signName: 'Teacher', detectionLabel: 'Teacher',
      handshape: 'Both hands in flat O shape near the temples',
      placement: 'Near the temples, on each side of the head',
      movement: 'Move both hands outward from temples, then add PERSON marker (flat hands brushing down)',
      facialExpression: 'Respectful, neutral expression',
      thinkAboutIt: 'TEACHER begins near the temples — where knowledge is held — and moves outward, as if sharing it. How does this spatial image reflect what a teacher does?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Student', 'Friend', 'Mother', 'Teacher'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'TEACHER — flat O hands move outward from the temples (sharing knowledge), followed by the PERSON marker.',
      contextScenario: 'You need to get your instructor\'s attention in class. You sign...',
      contextOptions: ['HELLO + MOTHER', 'SORRY + FRIEND', 'HELLO + TEACHER', 'PLEASE + STUDENT'],
      contextCorrectIndex: 2,
      contextExplanation: 'HELLO + TEACHER is the respectful, clear way to address your instructor. Always greet before making a request.',
      errorFeedback: 'Sign B omits the PERSON marker at the end. The PERSON marker is grammatically required for occupational signs in ASL.',
    ),

    'Student': SignContent(
      signName: 'Student', detectionLabel: null,
      handshape: 'Dominant open hand, non-dominant hand flat palm up',
      placement: 'Non-dominant palm stays; dominant hand moves from palm to forehead',
      movement: 'Dominant hand takes something from the non-dominant palm and brings it to the forehead',
      facialExpression: 'Attentive, open expression',
      thinkAboutIt: 'STUDENT looks like picking up knowledge from a book and bringing it to your head. How does this direction of movement convey the idea of learning?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Teacher', 'Book', 'Friend', 'Student'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'STUDENT — the dominant hand takes from the open palm and brings to the forehead, representing absorbing knowledge.',
      contextScenario: 'You are telling someone about your role at school. You sign...',
      contextOptions: ['TEACHER', 'FRIEND', 'I AM STUDENT', 'THANK YOU'],
      contextCorrectIndex: 2,
      contextExplanation: 'I + STUDENT establishes your identity clearly. In ASL, the subject often comes first to establish the topic.',
      errorFeedback: 'Sign B brings the hand to the chest instead of the forehead. STUDENT always ends at the forehead — that is where learning happens.',
    ),

    'Class': SignContent(
      signName: 'Class', detectionLabel: null,
      handshape: 'Both C handshapes — curved, like holding a cylinder',
      placement: 'In front of the body',
      movement: 'Both C hands start together and arc outward to the sides',
      facialExpression: 'Neutral, matter-of-fact',
      thinkAboutIt: 'CLASS shows a group of people arranged in an arc — like students seated in a semicircle. How does this spatial representation convey that CLASS is about a group?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Teacher', 'Book', 'Friend', 'Class'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'CLASS — both C handshapes arc outward from center, representing a group of people arranged in space.',
      contextScenario: 'You are telling a Deaf friend where you spend your mornings. You sign...',
      contextOptions: ['BOOK + PENCIL', 'TEACHER only', 'I GO CLASS', 'SORRY + PLEASE'],
      contextCorrectIndex: 2,
      contextExplanation: 'I GO CLASS establishes who (I), the action (GO), and the place (CLASS). Subject-verb-location order is natural in ASL.',
      errorFeedback: 'Sign B uses flat hands instead of C handshapes. The curved C shape represents the group of people. Flat hands change the meaning entirely.',
    ),

    'What': SignContent(
      signName: 'What', detectionLabel: null,
      handshape: 'Both open hands, palms up, fingers spread',
      placement: 'In front of the body, slightly forward',
      movement: 'Hands shake slightly side to side',
      facialExpression: 'Brows furrowed — this is grammatically required for WH-questions in ASL',
      thinkAboutIt: 'WHAT uses an open, uncertain gesture — palms up, slightly shaking. How is this open gesture different from signs that are more definitive?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Where', 'When', 'How', 'What'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'WHAT — open palms shake slightly side to side with furrowed brows. The facial expression signals it is a question.',
      contextScenario: 'A Deaf classmate signs something you did not catch. You sign...',
      contextOptions: ['SORRY only', 'PLEASE AGAIN', 'WHAT', 'TEACHER'],
      contextCorrectIndex: 2,
      contextExplanation: 'WHAT is a natural, direct request for clarification. Pair it with a genuinely questioning face to show you want to understand.',
      errorFeedback: 'Sign B has neutral eyebrows. WHAT is a WH-question — furrowed brows are grammatically required. Without them it is not read as a question.',
    ),

    'Where': SignContent(
      signName: 'Where', detectionLabel: null,
      handshape: 'Index finger extended',
      placement: 'In front of the body',
      movement: 'Index finger wags or shakes side to side',
      facialExpression: 'Brows furrowed — WH-question facial grammar',
      thinkAboutIt: 'WHERE wags the finger as if searching different directions. How does the wagging motion physically convey the idea of looking for a location?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['What', 'When', 'How', 'Where'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'WHERE — index finger wags side to side with furrowed brows, as if searching different directions for a location.',
      contextScenario: 'You cannot find the classroom. You ask a Deaf person nearby...',
      contextOptions: ['WHAT CLASS', 'WHERE CLASS', 'PLEASE HELP', 'SORRY TEACHER'],
      contextCorrectIndex: 1,
      contextExplanation: 'WHERE + CLASS is the natural structure for asking about location. You can point in a direction after signing WHERE for extra context.',
      errorFeedback: 'Sign B moves the finger up and down instead of side to side. WHERE specifically wags horizontally — up and down is used for different question signs.',
    ),

    'Read': SignContent(
      signName: 'Read', detectionLabel: null,
      handshape: 'Dominant V handshape (index and middle fingers); non-dominant hand flat',
      placement: 'Non-dominant hand represents a page; dominant V moves across it',
      movement: 'V handshape moves across the non-dominant palm, as if eyes scanning text',
      facialExpression: 'Focused, concentrated expression',
      thinkAboutIt: 'READ uses the V hand like two eyes scanning down a page. How does this visual metaphor help you remember what the sign represents?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Write', 'Book', 'Paper', 'Read'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'READ — the V handshape (representing eyes) moves across the non-dominant palm, mimicking eyes scanning a page.',
      contextScenario: 'Your teacher tells everyone to begin the assignment quietly. The expected activity is...',
      contextOptions: ['Write', 'Play', 'Eat', 'Read'],
      contextCorrectIndex: 3,
      contextExplanation: 'READ suggests quiet, focused study. The sign\'s mime of eyes on a page makes the activity immediately clear.',
      errorFeedback: 'Sign B uses all five fingers instead of just the V. READ specifically uses two fingers — representing two eyes scanning the page.',
    ),

    'Write': SignContent(
      signName: 'Write', detectionLabel: null,
      handshape: 'Dominant hand in modified O or G shape, as if holding a pen',
      placement: 'Non-dominant hand flat as a surface; dominant hand writes on it',
      movement: 'Dominant hand makes small writing motions across the non-dominant palm',
      facialExpression: 'Focused, task-oriented',
      thinkAboutIt: 'WRITE mimes the physical act of writing on a surface. What does it tell you about how sign language creates signs for abstract actions?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Read', 'Book', 'Pencil', 'Write'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'WRITE — the dominant hand mimes writing across the non-dominant palm, like signing your name on a piece of paper.',
      contextScenario: 'Your teacher asks you to complete a worksheet. The activity is...',
      contextOptions: ['Read', 'Play', 'Eat', 'Write'],
      contextCorrectIndex: 3,
      contextExplanation: 'WRITE versus READ: READ scans with the V hand (eyes), WRITE scripts with a pen-shaped hand. Both use the non-dominant palm as a surface.',
      errorFeedback: 'Sign B makes large, sweeping motions instead of small writing ones. WRITE involves precise, contained movement — like actual handwriting.',
    ),

    'Mother': SignContent(
      signName: 'Mother', detectionLabel: 'Mother',
      handshape: 'Open hand, thumb touching the chin',
      placement: 'At the chin',
      movement: 'Thumb taps the chin twice',
      facialExpression: 'Warm, family-oriented expression',
      thinkAboutIt: 'MOTHER taps the chin — female signs in ASL are generally placed at or below the nose. FATHER taps the forehead. How does this high/low distinction help organise family signs?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Father', 'Teacher', 'Friend', 'Mother'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'MOTHER — open hand with thumb tapping the chin twice. Female family signs sit at chin level in ASL.',
      contextScenario: 'You are talking about the woman who raised you. You sign...',
      contextOptions: ['TEACHER', 'SORRY', 'MOTHER', 'PLEASE'],
      contextCorrectIndex: 2,
      contextExplanation: 'Establish MOTHER first as the topic, then continue with what she does, her name, or other details. Topic-comment structure is natural in ASL.',
      errorFeedback: 'Sign B touches the forehead — that is FATHER. The chin (MOTHER) versus forehead (FATHER) distinction is one of the most important to remember.',
    ),

    'Father': SignContent(
      signName: 'Father', detectionLabel: 'Father',
      handshape: 'Open hand, thumb touching the forehead',
      placement: 'At the forehead',
      movement: 'Thumb taps the forehead twice',
      facialExpression: 'Respectful, family-oriented expression',
      thinkAboutIt: 'FATHER taps the forehead — male signs are generally placed at or above the nose level. How does this spatial pattern make the gender distinction systematic?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Mother', 'Friend', 'Teacher', 'Father'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'FATHER — open hand with thumb tapping the forehead twice. Male family signs sit at forehead level in ASL.',
      contextScenario: 'You are describing the man in your family photo. You sign...',
      contextOptions: ['MOTHER', 'FRIEND', 'FATHER', 'TEACHER'],
      contextCorrectIndex: 2,
      contextExplanation: 'FATHER establishes the topic clearly. You can follow with descriptors like TALL, FUNNY, or a name sign.',
      errorFeedback: 'Sign B touches the chin — that is MOTHER. Chin = female side, forehead = male side. This distinction changes the entire meaning.',
    ),

    'Sister': SignContent(
      signName: 'Sister', detectionLabel: null,
      handshape: 'L handshape (thumb and index finger extended), starts near chin then joins non-dominant fist',
      placement: 'Begins at the chin (female marker), then in front of the body',
      movement: 'L hand near chin then lands alongside or on the non-dominant hand (same/sibling)',
      facialExpression: 'Warm, family expression',
      thinkAboutIt: 'SISTER combines the female marker (chin area) with a same/sibling gesture. What does the "same" element tell you about the sibling relationship?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Mother', 'Friend', 'Brother', 'Sister'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'SISTER — the L handshape begins near the chin (female marker) and joins the non-dominant hand, meaning same female sibling.',
      contextScenario: 'You are describing your family and mention your female sibling. You sign...',
      contextOptions: ['MOTHER', 'BROTHER', 'FRIEND', 'SISTER'],
      contextCorrectIndex: 3,
      contextExplanation: 'SISTER specifically means a female sibling. Gender is encoded directly into the sign itself.',
      errorFeedback: 'Sign B starts at the forehead instead of the chin. Starting at the forehead would indicate a male relation — SISTER always begins at the chin area.',
    ),

    'Tall': SignContent(
      signName: 'Tall', detectionLabel: null,
      handshape: 'Flat hand, palm facing down',
      placement: 'Hand held high, indicating height in physical space',
      movement: 'Flat hand held at a raised level — the height of the hand represents the height of the person',
      facialExpression: 'Impressed or matter-of-fact expression',
      thinkAboutIt: 'TALL uses a high horizontal hand to mark height in space. How does using physical space to show size make this sign immediately intuitive?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Short', 'Big', 'Old', 'Tall'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'TALL — a flat palm-down hand held high represents height. The position of the hand in space is the meaning.',
      contextScenario: 'Describing your father, you note his height. You sign...',
      contextOptions: ['SHORT', 'YOUNG', 'OLD', 'TALL'],
      contextCorrectIndex: 3,
      contextExplanation: 'Height in ASL is shown by positioning your hand at the actual level of the person. TALL is intuitive and spatial.',
      errorFeedback: 'Sign B holds the hand low — that would indicate SHORT. The height of the hand in space is the entire meaning of this sign.',
    ),

    'Young': SignContent(
      signName: 'Young', detectionLabel: null,
      handshape: 'Both open hands, fingers bent at first knuckle',
      placement: 'At the shoulders and upper chest area',
      movement: 'Hands brush upward on the upper chest/shoulders repeatedly',
      facialExpression: 'Light, energetic expression',
      thinkAboutIt: 'YOUNG brushes upward on the chest — like the energy of youth rising. How does this upward, energetic motion differ from signs for OLD?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Old', 'Tall', 'Happy', 'Young'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'YOUNG — bent fingers brush upward at the shoulders/upper chest, suggesting the rising energy of youth.',
      contextScenario: 'You are describing someone who is a teenager. You sign...',
      contextOptions: ['OLD', 'TALL', 'SORRY', 'YOUNG'],
      contextCorrectIndex: 3,
      contextExplanation: 'YOUNG is relative — it describes someone as youthful, not just young in years. Pair it with a light facial expression.',
      errorFeedback: 'Sign B brushes downward instead of upward. YOUNG always moves upward — the downward direction conveys a different meaning entirely.',
    ),

    'Birthday': SignContent(
      signName: 'Birthday', detectionLabel: null,
      handshape: 'Dominant bent middle finger extended, other fingers closed',
      placement: 'Middle finger touches lips first, then taps the non-dominant palm',
      movement: 'Bent middle finger touches lip, then taps the non-dominant palm',
      facialExpression: 'Happy, celebratory expression',
      thinkAboutIt: 'BIRTHDAY combines elements of BIRTH and DAY. How does thinking of compound signs in terms of their components help you remember them?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Happy', 'Old', 'Name', 'Birthday'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'BIRTHDAY — the bent middle finger touches the lips then the palm. It is a compound of BIRTH + DAY.',
      contextScenario: 'Your friend\'s special annual day is coming up. To ask about it you sign...',
      contextOptions: ['YOUR NAME', 'YOUR BIRTHDAY', 'YOUR AGE', 'YOUR PLEASE'],
      contextCorrectIndex: 1,
      contextExplanation: 'YOUR BIRTHDAY (pointing to person + BIRTHDAY) is the natural way to ask or comment on someone\'s birthday.',
      errorFeedback: 'Sign B uses the index finger instead of the middle finger. BIRTHDAY specifically uses the bent middle finger — the choice of finger matters.',
    ),

    'Old': SignContent(
      signName: 'Old', detectionLabel: null,
      handshape: 'S handshape (fist) starting at the chin',
      placement: 'Starts at the chin',
      movement: 'Hand drops downward, miming the gesture of stroking a long beard',
      facialExpression: 'Wise, measured expression',
      thinkAboutIt: 'OLD mimes pulling a long beard downward from the chin. Beards as symbols of wisdom appear across many cultures. Why do you think this image was chosen for this sign?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Young', 'Tall', 'Name', 'Old'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'OLD — the fist at the chin pulls downward, miming the gesture of stroking a long beard.',
      contextScenario: 'You are describing an elderly family member. You sign...',
      contextOptions: ['YOUNG', 'TALL', 'HAPPY', 'OLD'],
      contextCorrectIndex: 3,
      contextExplanation: 'OLD describes age informally. Pair it with a respectful expression — ASL does not carry negative connotations for age.',
      errorFeedback: 'Sign B moves the hand upward instead of downward. OLD always drops down from the chin — it is a downward pulling motion.',
    ),

    'Love': SignContent(
      signName: 'Love', detectionLabel: null,
      handshape: 'Both arms crossed over the chest',
      placement: 'At the chest, centered at the heart',
      movement: 'Cross arms and hug them to the chest',
      facialExpression: 'Warm, sincere expression — the face carries significant meaning here',
      thinkAboutIt: 'LOVE crosses both arms over the heart — a universal symbol of affection. How does using the chest as the location reinforce the emotional nature of this sign?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Friend', 'Sorry', 'Happy', 'Love'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'LOVE — both arms cross over the chest and hug inward, centered at the heart.',
      contextScenario: 'You want to express deep affection for your family. You sign...',
      contextOptions: ['FRIEND + PLEASE', 'I SORRY', 'THANK YOU only', 'I LOVE YOU'],
      contextCorrectIndex: 3,
      contextExplanation: 'I LOVE YOU (or the one-handed ILY handshape) is one of the most recognised signs. Crossed arms on chest is the fuller, more expressive form.',
      errorFeedback: 'Sign B crosses only one arm over the chest. LOVE uses both arms crossed — one-armed crossing is incomplete.',
    ),

    'Together': SignContent(
      signName: 'Together', detectionLabel: null,
      handshape: 'Both A handshapes (fists) with thumbs up',
      placement: 'In front of the body',
      movement: 'Both fists move in a circle together, staying close to each other',
      facialExpression: 'Inclusive, warm expression',
      thinkAboutIt: 'TOGETHER keeps both fists moving in unison — literally as one. How does synchronized movement between two hands communicate togetherness?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Friend', 'Sorry', 'Please', 'Together'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'TOGETHER — both fists circle together in front of the body, moving as one unit to show unity.',
      contextScenario: 'You invite a Deaf friend to do an activity as a pair. You sign...',
      contextOptions: ['PLEASE SORRY', 'WE TOGETHER', 'THANK YOU FRIEND', 'GOODBYE PLEASE'],
      contextCorrectIndex: 1,
      contextExplanation: 'WE + TOGETHER emphasizes that you want to do something jointly. It is warm and inclusive.',
      errorFeedback: 'Sign B moves the fists in opposite directions. TOGETHER requires both fists to move in the same circular direction, staying close.',
    ),

    'Eat': SignContent(
      signName: 'Eat', detectionLabel: null,
      handshape: 'Dominant hand in a flat O shape (fingers touching thumb)',
      placement: 'At the mouth',
      movement: 'Hand moves toward the mouth repeatedly, as if bringing food',
      facialExpression: 'Natural, neutral or content expression',
      thinkAboutIt: 'EAT mimes bringing food to the mouth — a universal gesture that exists across many cultures. Why do you think iconic mimed signs are often the easiest to remember?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Drink', 'Cook', 'Play', 'Eat'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'EAT — the flat O hand moves toward the mouth repeatedly, directly miming the action of eating.',
      contextScenario: 'Your family sits down for dinner. The activity everyone is doing is...',
      contextOptions: ['PLAY', 'WRITE', 'DRINK', 'EAT'],
      contextCorrectIndex: 3,
      contextExplanation: 'EAT is one of ASL\'s most iconic signs. You can modify its speed and expression to show eating quickly, slowly, or enthusiastically.',
      errorFeedback: 'Sign B brings the hand to the chin instead of the mouth. EAT targets the mouth specifically — chin placement changes the sign.',
    ),

    'Play': SignContent(
      signName: 'Play', detectionLabel: null,
      handshape: 'Both hands in Y handshape (thumb and pinky extended)',
      placement: 'In front of the body',
      movement: 'Both Y hands shake/wiggle loosely back and forth from the wrist',
      facialExpression: 'Fun, energetic, light expression',
      thinkAboutIt: 'PLAY uses the Y handshape in a loose, free-swinging motion. How does the casual, unrestrained movement of this sign reflect the nature of play itself?',
      recognitionQuestion: 'What does this sign mean?',
      recognitionOptions: ['Eat', 'Write', 'Sorry', 'Play'],
      recognitionCorrectIndex: 3,
      recognitionExplanation: 'PLAY — both Y handshapes wiggle loosely in front of the body, suggesting free, joyful movement.',
      contextScenario: 'After school, your family does a fun activity together. You sign...',
      contextOptions: ['EAT', 'WRITE', 'SORRY', 'PLAY'],
      contextCorrectIndex: 3,
      contextExplanation: 'PLAY can describe games, sports, or unstructured fun. Pair it with an energetic expression to convey enjoyment.',
      errorFeedback: 'Sign B shakes the whole arms. PLAY\'s movement comes from the wrists only — the loose, wrist-based wiggle is the key motion.',
    ),
  };
}

// ── GIF asset map (keyed by sign name) ─────────────────────────────────────

class SignGifMap {
  static String? gif(String signName) => _gifs[signName];

  static const Map<String, String> _gifs = {
    'Hello': 'assets/gifs/hello.gif',
    // Add entries below as GIFs are produced:
    // 'Goodbye': 'assets/gifs/goodbye.gif',
    // 'Thank You': 'assets/gifs/thank_you.gif',
    // 'Please': 'assets/gifs/please.gif',
    // 'Sorry': 'assets/gifs/sorry.gif',
    // 'Yes': 'assets/gifs/yes.gif',
    // 'No': 'assets/gifs/no.gif',
    // 'Teacher': 'assets/gifs/teacher.gif',
    // 'Mother': 'assets/gifs/mother.gif',
    // 'Father': 'assets/gifs/father.gif',
    // 'Friend': 'assets/gifs/friend.gif',
  };
}

// ── Video asset map (keyed by lesson ID) ────────────────────────────────────

class LessonVideoMap {
  static String? correctVideo(String lessonId) => _correctVideos[lessonId];
  static String? incorrectVideo(String lessonId) => _incorrectVideos[lessonId];

  static const Map<String, String> _correctVideos = {
    'u1l1': 'assets/videos/u1l1_hello_correct.mp4',
  };

  static const Map<String, String> _incorrectVideos = {
    'u1l1': 'assets/videos/u1l1_hello_incorrect.mp4',
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
        handshape: 'Open hand, fingers together', movement: 'Hand moves away from forehead in a salute-like motion',
        placement: 'Starts near the forehead', commonMistake: 'Moving the hand too far from the face',
        exampleContext: 'Use when greeting a friend or meeting someone new'),
    VocabularyItem(sign: 'Thank You', meaning: 'Expression of gratitude', category: 'Everyday',
        handshape: 'Flat hand, palm facing you', movement: 'Hand moves forward from chin',
        placement: 'Starts at the chin', commonMistake: 'Starting too low — should begin at chin level',
        exampleContext: 'After receiving help or a gift'),
    VocabularyItem(sign: 'Please', meaning: 'Polite request word', category: 'Everyday',
        handshape: 'Flat hand on chest', movement: 'Circular motion on the chest',
        placement: 'Center of chest', commonMistake: 'Making the circle too small',
        exampleContext: 'When asking someone for something politely'),
    VocabularyItem(sign: 'Sorry', meaning: 'Expression of apology', category: 'Everyday',
        handshape: 'Fist with thumb extended (A handshape)', movement: 'Circular motion on chest',
        placement: 'Center of chest', commonMistake: 'Confusing with PLEASE — Sorry uses a fist, Please uses flat hand',
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

  static List<String> get categories =>
      sampleItems.map((e) => e.category).toSet().toList();
}