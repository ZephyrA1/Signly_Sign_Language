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
      contextOptions: ['Wait for them to approach you', 'Wave from a distance and look away', 'Make eye contact, then sign HELLO', 'Sign THANK YOU to show respect'],
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
      contextOptions: ['Hello to welcome them back later', 'Please to ask them to stay', 'Sorry for the conversation ending', 'Goodbye to close the interaction warmly'],
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
      contextOptions: ['Can you help me?', 'Nice to meet you what is your name?', 'Where are you from?', 'Do you know sign language?'],
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
      contextOptions: ['HELLO again to re greet them', 'SORRY in case you signed something wrong', 'NICE MEET YOU the standard expression', 'THANK YOU for being introduced'],
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
      contextOptions: ['Nod your head no sign needed', 'Sign SORRY you feel bad for the trouble', 'Sign HELLO to formally acknowledge them', 'Sign THANK YOU with a genuine expression'],
      contextCorrectIndex: 3,
      contextExplanation: 'THANK YOU is the natural response to any act of kindness. A genuine facial expression carries as much meaning as the sign itself in Deaf culture.',
      errorFeedback: 'Sign B starts at the forehead instead of the chin. THANK YOU originates at the chin starting at the forehead is a completely different sign.',
    ),

    'How': SignContent(
      signName: 'How', detectionLabel: null,
      handshape: 'Both hands in curved/bent shape, knuckles touching',
      placement: 'In front of the body',
      movement: 'Hands rotate forward and apart, ending palms up',
      facialExpression: 'Raised eyebrows this is a question word and requires facial grammar',
      thinkAboutIt: 'HOW involves both hands rotating open. In ASL, open palms often signal a question or openness. How does this connect to asking "how"?',
      recognitionQuestion: 'Both hands meet with bent knuckles, then rotate open with palms facing up. The signer has raised eyebrows. What are they asking?',
      recognitionOptions: ['Where something is', 'How something is or was done', 'What something is called', 'When something happened'],
      recognitionCorrectIndex: 1,
      recognitionExplanation: 'HOW knuckles touching, hands rotate open to palms up. Raised eyebrows are grammatically required for all question words in ASL.',
      contextScenario: 'You run into a Deaf friend you have not seen in a while. After greeting them, what is the most natural follow up?',
      contextOptions: ['GOODBYE wrap up quickly', 'WHERE YOU ask where they have been', 'HOW YOU check in on how they are doing', 'PLEASE HELP ask for assistance'],
      contextCorrectIndex: 2,
      contextExplanation: 'HOW YOU (or HOW ARE YOU) is the natural warm follow up after a greeting. The raised eyebrows throughout are grammatically required.',
      errorFeedback: 'Sign B rotates the hands so the palms face downward at the end. HOW always finishes palms up downward palms completely change the meaning.',
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
      contextOptions: ['THANK YOU even before they agree', 'SORRY in case they say no', 'PLEASE before making your request', 'HELLO to re greet them first'],
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
      contextOptions: ['HAPPY with a big smile to seem enthusiastic', 'SORRY you have not signed before', 'FINE a casual, honest response', 'THANK YOU to show appreciation for asking'],
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
      contextOptions: ['STUDENT they go to school together', 'TEACHER they taught you something', 'MY FRIEND the natural introduction', 'SORRY in case of awkwardness'],
      contextCorrectIndex: 2,
      contextExplanation: 'MY FRIEND establishes the relationship before you give the name. In ASL, identifying the relationship first helps set context for the introduction.',
      errorFeedback: 'Sign B hooks the fingers but moves them up and down rather than switching which is on top. The switch is essential without it the sign is incomplete.',
    ),

    'This Is': SignContent(
      signName: 'This Is', detectionLabel: null,
      handshape: 'Index finger extended (pointing gesture)',
      placement: 'Directed toward the person or thing being indicated',
      movement: 'Point the index finger toward the referent, then sign their name or role',
      facialExpression: 'Open, inclusive looking between both people when introducing',
      thinkAboutIt: 'Pointing in ASL is a pronoun THIS/HE/SHE/IT depending on context. How is pointing in sign language more direct than using a spoken pronoun?',
      recognitionQuestion: 'A signer points their index finger directly toward a person standing nearby. What grammatical function is this performing?',
      recognitionOptions: ['Criticising them', 'Asking them a question', 'Establishing them as the topic', 'Saying goodbye to them'],
      recognitionCorrectIndex: 2,
      recognitionExplanation: 'Pointing in ASL is a pronoun THIS, HE, SHE, or IT depending on context. It establishes the referent before describing them.',
      contextScenario: 'You are introducing your friend to someone new. After signing HELLO, the next step is to...',
      contextOptions: ['Sign GOODBYE to close the first greeting', 'Sign SORRY in case they do not like each other', 'Point to your friend, then sign FRIEND or their name', 'Wait for your friend to introduce themselves'],
      contextCorrectIndex: 2,
      contextExplanation: 'Pointing to establish the referent first is natural ASL grammar. You point to the person, then describe who they are topic before comment.',
      errorFeedback: 'Sign B uses the full open hand to gesture toward the person. Pointing in ASL always uses the index finger only a full hand gesture has a different meaning.',
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
      contextOptions: ['Smile and shrug noncommittally', 'Sign MAYBE to seem polite', 'Sign PLEASE to accept formally', 'Sign YES with a nod clear and enthusiastic'],
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
      contextOptions: ['Say nothing and look away', 'Sign SORRY and wave it off', 'Sign NO clearly with a slight head shake', 'Sign GOODBYE to end the interaction'],
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
      contextOptions: ['YES even though you are unsure', 'NO to avoid committing', 'SORRY as if it is already a problem', 'MAYBE honest and open'],
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
      contextOptions: ['Walk away you do not want to cause frustration', 'Sign SORRY and then HELP PLEASE to ask them to repeat', 'Sign NO to indicate you did not understand', 'Just nod even if you did not understand'],
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
      contextOptions: ['PLEASE hoping they will forgive you', 'HELLO to restart the interaction', 'SORRY with a genuine apologetic expression', 'THANK YOU for their patience'],
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
      contextOptions: ['FINE an understatement of how you feel', 'SORRY out of habit', 'PLEASE wanting them to share the moment', 'HAPPY with energy that matches how you feel'],
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
      contextOptions: ['HAPPY to try to cheer them up immediately', 'SORRY and SAD to acknowledge their feelings', 'FINE to reassure them things will be okay', 'GOODBYE to give them space'],
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
      contextOptions: ['Pencil to start writing notes', 'Paper for the worksheet', 'Book for the reading activity', 'Chair to sit down'],
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
      contextOptions: ['WRITE to describe what you need to do', 'PAPER thinking you need paper too', 'PENCIL the specific tool you are asking for', 'BOOK pointing at their bag'],
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
      contextOptions: ['Book in case they want the textbook too', 'Pencil to fill in any remaining answers', 'Paper the assignment sheet itself', 'Chair you misread the instruction'],
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
      contextOptions: ['STUDENT apologising to a classmate', 'FRIEND it is informal enough', 'MOTHER out of habit', 'TEACHER the appropriate person to apologise to'],
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
      contextOptions: ['TEACHER you accidentally use the wrong role', 'FRIEND to seem approachable', 'STUDENT the accurate description of your role', 'BOOK pointing to what you carry'],
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
      contextOptions: ['BOOK you just carry books', 'TEACHER to find your instructor', 'HOME you study at home', 'CLASS you attend lessons in the morning'],
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
      contextOptions: ['WHERE thinking they mentioned a location', 'SORRY AGAIN to ask for a full repeat', 'WHAT to ask them to clarify the specific thing', 'HELLO to restart the conversation'],
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
      contextOptions: ['WHAT CLASS asking the name of the class', 'SORRY TEACHER apologising to a teacher', 'WHERE CLASS asking for the location', 'HELLO STUDENT greeting a student'],
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
      contextOptions: ['Write answers on the paper', 'Play quietly with a partner', 'Eat their lunch early', 'Read the assigned passage'],
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
      contextOptions: ['Read the questions aloud', 'Draw diagrams for the answers', 'Write your answers on the paper', 'Put the paper away'],
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
      contextOptions: ['TEACHER because she taught you things', 'FRIEND to keep it informal', 'SISTER confusing the relationship', 'MOTHER the correct family sign'],
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
      contextOptions: ['TEACHER because he taught you things', 'FRIEND to keep it informal', 'MOTHER accidentally using the wrong sign', 'FATHER the correct family sign'],
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
      contextOptions: ['MOTHER too general', 'FRIEND not quite right for a sibling', 'BROTHER wrong gender', 'SISTER precise and correct'],
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
      contextOptions: ['OLD describing his age first', 'YOUNG comparing him to others', 'SHORT choosing the wrong direction', 'TALL describing his height accurately'],
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
      contextOptions: ['OLD confusing their age', 'TALL describing their height instead', 'SORRY out of habit', 'YOUNG accurately describing their age'],
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
      contextOptions: ['A test they are worried about', 'Their upcoming birthday', 'A new classroom rule', 'Their homework deadline'],
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
      contextOptions: ['YOUNG describing them as youthful', 'HAPPY describing their mood instead', 'TALL talking about their height', 'OLD describing their age accurately'],
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
      contextOptions: ['SORRY in case you said anything wrong', 'PLEASE asking them to call again', 'FINE to say you are doing well', 'I LOVE YOU a warm and meaningful close'],
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
      contextOptions: ['SORRY you feel awkward asking', 'GOODBYE you are leaving ahead', 'WE GO TOGETHER the natural invitation', 'PLEASE HELP asking for assistance'],
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
      contextOptions: ['PLAY have fun before eating', 'WRITE note down the menu', 'DRINK just have beverages', 'EAT sit down for the meal'],
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
      contextOptions: ['EAT they want a snack', 'WRITE more homework', 'SORRY they feel bad interrupting', 'PLAY they want to have fun'],
      contextCorrectIndex: 3,
      contextExplanation: 'PLAY is the natural sign for unstructured fun games, sports, or just hanging out. The loose wrist motion reflects the freedom of play itself.',
      errorFeedback: 'Sign B shakes both arms from the shoulder. PLAY is a wrist movement the arms stay relatively still. Full arm shaking looks like a completely different sign.',
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

  static List<String> get categories =>
      sampleItems.map((e) => e.category).toSet().toList();
}