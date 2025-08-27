import 'package:bonyan/models/models.dart'; // افترض أن هذا المسار صحيح وأن النماذج معرّفة فيه

// --- SINGLE INSTANCES ---

final mockUser = UserModel(
  id: 'user-123',
  fullName: 'محمد',
  phoneNumber: '+967 777 777 777',
  avatarUrl:
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=100&auto=format&fit=crop',
  role: 'عميل',
);

final mockProfessional = ProfessionalModel(
  id: 'prof-khaled',
  name: 'خالد الأحمد',
  specialty: 'مقاول عام',
  location: 'صنعاء, حي النهضة',
  rating: 4.9,
  reviewCount: 125,
  avatarUrl:
      'https://images.unsplash.com/photo-1599305445671-ac291c9a87bb?q=80&w=1770&auto=format&fit=crop',
  backgroundUrl:
      'https://images.unsplash.com/photo-1599305445671-ac291c9a87bb?q=80&w=1770&auto=format&fit=crop',
  isVerified: true,
  acceptsWarrantyPayment: true,
  bio:
      'مقاول عام بخبرة تزيد عن 15 عامًا في مجال بناء الفلل والمباني السكنية في صنعاء. متخصص في إدارة المشاريع من البداية وحتى التسليم.',
  portfolioImageUrls: [
    'https://images.unsplash.com/photo-1541888946-b60e65306385?q=80&w=1770&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1497366811234-a15e6123b3b4?q=80&w=1770&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1568605117036-ba68f9edd2d1?q=80&w=1770&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1581092281987-a36c4832585c?q=80&w=1770&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1576081491294-b258671603ba?q=80&w=1770&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1558002047-975945447781?q=80&w=1770&auto=format&fit=crop',
  ],
);

final mockSupplier = SupplierModel(
  id: 'sup-nahda',
  name: 'مؤسسة النهضة للمقاولات',
  specialty: 'تجارة مواد بناء',
  rating: 4.8,
  reviewCount: 210,
  avatarUrl:
      'https://images.unsplash.com/photo-1543269865-cbf427effcbb?q=80&w=1770&auto=format&fit=crop',
  deliveryPolicy:
      'نوفر خدمة التوصيل داخل صنعاء بتكلفة إضافية. الاستلام من المحل متاح خلال ساعات العمل.',
);

// --- LISTS ---

final List<ProductModel> mockProducts = [
  ProductModel(
    id: 'prod-cement',
    name: 'إسمنت المقاوم',
    price: 4500,
    unit: 'للكيس (50 كجم)',
    imageUrl:
        'https://images.unsplash.com/photo-1582234293933-289520e588b3?q=80&w=1770&auto=format&fit=crop',
    supplierId: 'sup-nahda',
    supplierName: 'مؤسسة النهضة للمقاولات',
    description: 'إسمنت مقاوم عالي الجودة للأعمال الخرسانية.',
    stock: 500,
  ),
  ProductModel(
    id: 'prod-red-brick',
    name: 'طوب أحمر',
    price: 150,
    unit: 'للقطعة',
    imageUrl:
        'https://images.unsplash.com/photo-1580211105152-32a18f4e6b1d?q=80&w=1770&auto=format&fit=crop',
    supplierId: 'sup-nahda',
    supplierName: 'مؤسسة النهضة للمقاولات',
    description: 'طوب أحمر عالي الجودة للبناء.',
    stock: 10000,
  ),
  ProductModel(
    id: 'prod-concrete-block',
    name: 'بلك أسمنتي',
    price: 250,
    unit: 'للقطعة',
    imageUrl:
        'https://images.unsplash.com/photo-1601053073041-e97d19e9e1b2?q=80&w=1770&auto=format&fit=crop',
    supplierId: 'sup-nahda',
    supplierName: 'مؤسسة النهضة للمقاولات',
    description:
        'بلك أسمنتي مصمت عالي الجودة مقاس 20x20x40 سم. مثالي لأعمال البناء والجدران الحاملة.',
    stock: 8000,
  ),
];

final List<ProjectModel> mockActiveProjects = [
  ProjectModel(
    id: 'proj-villa-nahda',
    name: 'بناء فيلا - حي النهضة',
    status: 'قيد التنفيذ: صب القواعد',
    progress: 0.45,
    type: ProjectType.humanResource,
    userId: '',
  ),
  ProjectModel(
    id: 'proj-apt-finishing',
    name: 'تشطيب شقة',
    status: 'قيد التنفيذ: أعمال الدهان',
    progress: 0.80,
    type: ProjectType.humanResource,
    userId: '',
  ),
];

final List<ProjectModel> mockAllMyProjects = [
  ProjectModel(
    id: 'proj-villa-nahda',
    name: 'بناء فيلا - حي النهضة',
    status: 'قيد التنفيذ',
    progress: 0.45,
    type: ProjectType.humanResource,
    userId: '',
  ),
  ProjectModel(
    id: 'proj-materials-1024',
    name: 'طلب مواد بناء #1024',
    status: 'جاهز للاستلام',
    type: ProjectType.purchaseRequest,
    userId: '',
  ),
];

final List<ProfessionalModel> mockRecommendedProfessionals = [
  mockProfessional,
  ProfessionalModel(
    id: 'prof-mohamed',
    name: 'محمد علي',
    specialty: 'مقاول تشطيبات',
    location: 'صنعاء, حي التحرير',
    rating: 4.8,
    reviewCount: 98,
    avatarUrl:
        'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=1887&auto=format&fit=crop',
    isVerified: true,
    acceptsWarrantyPayment: false,
    bio: 'مقاول تشطيبات متخصص في أعمال الدهانات والديكورات الداخلية.',
    portfolioImageUrls: [],
  ),
];

final List<ReviewModel> mockMyReviews = [
  ReviewModel(
    id: 'rev-1',
    targetName: 'خالد الأحمد',
    rating: 5.0,
    comment: 'عمل ممتاز ومواعيد دقيقة.',
    date: DateTime.now().subtract(const Duration(days: 5)),
    authorName: 'محمد',
    authorId: '',
    targetId: '',
  ),
  ReviewModel(
    id: 'rev-2',
    targetName: 'مؤسسة النهضة',
    rating: 4.0,
    comment: 'جودة المواد ممتازة.',
    date: DateTime.now().subtract(const Duration(days: 15)),
    authorName: 'محمد',
    authorId: '',
    targetId: '',
  ),
];

final List<NotificationModel> mockNotifications = [
  NotificationModel(
    id: 'notif-1',
    title: 'عرض سعر جديد',
    body: 'قدم خالد الأحمد عرض سعر لمشروع "بناء فيلا".',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    type: NotificationType.offer,
    isRead: false,
    userId: '',
  ),
  NotificationModel(
    id: 'notif-2',
    title: 'تم تأكيد الدفعة',
    body: 'تم تأكيد استلام دفعة الضمان لمشروع "تشطيب شقة".',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    type: NotificationType.payment,
    isRead: true,
    userId: '',
  ),
  NotificationModel(
    id: 'notif-3',
    title: 'طلب صرف مستحقات',
    body: 'طلب المقاول محمد علي صرف مستحقات مرحلة "أعمال الدهان".',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    type: NotificationType.milestone,
    isRead: true,
    userId: '',
  ),
];

final List<ChatThreadModel> mockChatThreads = [
  ChatThreadModel(
    id: 'chat-1',
    otherPartyName: 'خالد الأحمد',
    otherPartyAvatarUrl:
        'https://images.unsplash.com/photo-1599305445671-ac291c9a87bb?q=80&w=1770&auto=format&fit=crop',
    lastMessage: 'تمام، سأرسل لك الصور فوراً.',
    lastMessageTimestamp: DateTime.now().subtract(const Duration(hours: 1)),
    unreadCount: 0,
    isOnline: true,
    participantIds: [],
  ),
  ChatThreadModel(
    id: 'chat-2',
    otherPartyName: 'مؤسسة النهضة',
    otherPartyAvatarUrl:
        'https://images.unsplash.com/photo-1543269865-cbf427effcbb?q=80&w=1770&auto=format&fit=crop',
    lastMessage: 'طلبك جاهز للاستلام.',
    lastMessageTimestamp: DateTime.now().subtract(const Duration(days: 1)),
    unreadCount: 1,
    isOnline: false, participantIds: [],
    // تم حذف participantIds من هنا ليتوافق مع العنصر الأول
  ),
];

final Map<String, List<ChatMessageModel>> mockChatMessages = {
  'chat-1': [
    ChatMessageModel(
      id: 'msg-1-1',
      text: 'السلام عليكم، متى يمكن البدأ في مرحلة الأعمدة؟',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 2)),
      senderId: 'user-123',
      isMe: true,
    ),
    ChatMessageModel(
      id: 'msg-1-2',
      text:
          'وعليكم السلام، يمكننا البدأ غداً صباحاً إن شاء الله. سأرسل لك صور حديد التسليح للمعاينة.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      senderId: 'prof-khaled',
      isMe: false,
    ),
  ],
  'chat-2': [
    ChatMessageModel(
      id: 'msg-2-1',
      text: 'طلبك جاهز للاستلام.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      senderId: 'sup-nahda',
      isMe: false,
    ),
  ],
};
