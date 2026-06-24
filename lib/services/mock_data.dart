import '../models/app_notification.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/order_status.dart';
import '../models/order_type.dart';
import '../models/seller_profile.dart';

/// Demo fixtures decoded from the design prototype. The stub ApiServices serve
/// these until the backend is wired; swap them for live `Dio` calls then.
class MockData {
  MockData._();

  static const SellerProfile profile = SellerProfile(
    storeName: 'Layla’s Sweets',
    storeNameAr: 'حلويات ليلى',
    avatar: 'assets/seller-avatar.jpg',
    openNow: true,
  );

  static List<Order> orders() => [
        const Order(
          id: 1042,
          customer: 'Mariam Al Hosani',
          status: OrderStatus.pending,
          total: 245,
          placed: 8,
          deliver: 'Today · 6:00 PM',
          date: '2026-06-23',
          payment: PaymentMethod.paid,
          tags: [OrderType.gift],
          due: 78,
          sla: 120,
          items: [
            OrderItem(name: 'Pistachio Celebration Cake', nameAr: 'كيكة الفستق للاحتفال', qty: 1, image: 'assets/p-pistachio.jpg'),
            OrderItem(name: 'Date Maamoul Box', nameAr: 'علبة معمول بالتمر', qty: 2, image: 'assets/p-maamoul-date.jpg'),
          ],
          note: 'Please write “Happy Birthday Sara” on the cake in gold piping. A little less sugar if you can. Match the colours to the photos I attached 💛',
          noteAr: 'الرجاء كتابة «عيد ميلاد سعيد سارة» على الكيكة بخط ذهبي. سكر أقل قليلاً إن أمكن. طابقوا الألوان مع الصور المرفقة 💛',
          images: ['assets/ref-cake-1.jpg', 'assets/ref-cake-2.jpg'],
        ),
        const Order(
          id: 1041,
          customer: 'Khalid Rashed',
          status: OrderStatus.pending,
          total: 120,
          placed: 22,
          deliver: 'Today · 4:00 PM',
          date: '2026-06-23',
          payment: PaymentMethod.cod,
          tags: [OrderType.express],
          due: 27,
          sla: 90,
          items: [
            OrderItem(name: 'Kunafa Tray (Medium)', nameAr: 'صينية كنافة وسط', qty: 1, image: 'assets/p-kunafa.jpg'),
            OrderItem(name: 'Lotus Cheesecake Slice', nameAr: 'شريحة تشيز كيك لوتس', qty: 4, image: 'assets/p-cheesecake.jpg'),
          ],
          note: 'Deliver before 4 PM please. Gate code is 4421, second villa on the right.',
          noteAr: 'الرجاء التوصيل قبل الساعة الرابعة. رمز البوابة 4421، الفيلا الثانية على اليمين.',
          images: ['assets/ref-cake-3.jpg'],
        ),
        const Order(
          id: 1043,
          customer: 'Yousef Karam',
          status: OrderStatus.pending,
          total: 75,
          placed: 35,
          deliver: 'Tomorrow · 11:00 AM',
          date: '2026-06-23',
          payment: PaymentMethod.cod,
          tags: [OrderType.gift, OrderType.scheduled],
          due: 14,
          sla: 180,
          items: [
            OrderItem(name: 'Assorted Maamoul Box', nameAr: 'علبة معمول مشكّل', qty: 1, image: 'assets/p-maamoul-assort.jpg'),
          ],
          note: 'Gift wrap please, it’s a present.',
          noteAr: 'الرجاء تغليفها كهدية.',
          images: [],
        ),
        const Order(
          id: 1040,
          customer: 'Aisha Saeed',
          status: OrderStatus.accepted,
          total: 310,
          placed: 60,
          deliver: 'Fri · 5:00 PM',
          date: '2026-06-22',
          payment: PaymentMethod.paid,
          tags: [OrderType.vip],
          due: -12,
          sla: 180,
          items: [
            OrderItem(name: '3-Tier Celebration Cake', nameAr: 'كيكة ثلاث طبقات للاحتفال', qty: 1, image: 'assets/p-tier-cake.jpg'),
          ],
          note: 'Buttercream finish, pastel blue & white. Please follow the reference photos closely.',
          noteAr: 'تشطيب بكريمة الزبدة، أزرق فاتح وأبيض. الرجاء اتباع الصور المرجعية بدقة.',
          images: ['assets/ref-cake-2.jpg', 'assets/ref-cake-4.jpg'],
        ),
        const Order(
          id: 1039,
          customer: 'Omar Yusuf',
          status: OrderStatus.onWay,
          total: 85,
          placed: 90,
          deliver: 'Today · 2:30 PM',
          date: '2026-06-22',
          payment: PaymentMethod.cod,
          tags: [OrderType.express],
          due: 42,
          sla: 60,
          items: [
            OrderItem(name: 'Fudge Brownie Box (12)', nameAr: 'علبة براوني فدج (12)', qty: 1, image: 'assets/p-brownie.jpg'),
          ],
          note: '',
          noteAr: '',
          images: [],
        ),
        const Order(
          id: 1038,
          customer: 'Fatima Noor',
          status: OrderStatus.delivered,
          total: 160,
          placed: 180,
          deliver: 'Delivered · 1:10 PM',
          date: '2026-06-20',
          payment: PaymentMethod.paid,
          tags: [OrderType.pickup],
          items: [
            OrderItem(name: 'Baklava Assortment', nameAr: 'تشكيلة بقلاوة', qty: 2, image: 'assets/p-baklava.jpg'),
          ],
          note: 'Leave with the reception desk.',
          noteAr: 'اتركوها مع مكتب الاستقبال.',
          images: [],
        ),
        const Order(
          id: 1037,
          customer: 'Hamad Ali',
          status: OrderStatus.cancelled,
          total: 95,
          placed: 240,
          deliver: 'Cancelled',
          date: '2026-06-17',
          payment: PaymentMethod.cod,
          tags: [OrderType.scheduled],
          items: [
            OrderItem(name: 'Vanilla Cupcakes (6)', nameAr: 'كب كيك فانيلا (6)', qty: 1, image: 'assets/p-cupcakes.jpg'),
          ],
          note: '',
          noteAr: '',
          images: [],
        ),
        const Order(
          id: 1036,
          customer: 'Noura Salem',
          status: OrderStatus.rejected,
          total: 540,
          placed: 300,
          deliver: 'Rejected',
          date: '2026-06-12',
          payment: PaymentMethod.paid,
          tags: [OrderType.vip, OrderType.scheduled],
          items: [
            OrderItem(name: 'Wedding Dessert Table', nameAr: 'طاولة حلويات زفاف', qty: 1, image: 'assets/p-wedding.jpg'),
          ],
          note: 'Needed tomorrow morning — is that possible?',
          noteAr: 'مطلوبة صباح الغد — هل هذا ممكن؟',
          images: ['assets/ref-cake-4.jpg'],
        ),
      ];

  static List<AppNotification> notifications() => const [
        AppNotification(
          id: 1, group: NotifGroup.today, tone: NotifTone.brand, icon: 'bag', unread: true,
          title: 'New order #1042', body: 'Mariam Al Hosani placed an order for AED 245.',
          titleAr: 'طلب جديد #1042', bodyAr: 'قدّمت مريم الحوسني طلباً بقيمة 245 د.إ.',
          time: '8m', timeAr: '٨ د',
        ),
        AppNotification(
          id: 2, group: NotifGroup.today, tone: NotifTone.amber, icon: 'clock', unread: true,
          title: 'Delivery reminder', body: 'Order #1041 should be delivered before 4:00 PM.',
          titleAr: 'تذكير بالتوصيل', bodyAr: 'يجب توصيل الطلب #1041 قبل الساعة 4:00 مساءً.',
          time: '1h', timeAr: 'ساعة',
        ),
        AppNotification(
          id: 3, group: NotifGroup.today, tone: NotifTone.green, icon: 'wallet', unread: false,
          title: 'Payout sent', body: 'AED 1,240 was transferred to your bank account.',
          titleAr: 'تم إرسال الدفعة', bodyAr: 'تم تحويل 1,240 د.إ إلى حسابك البنكي.',
          time: '3h', timeAr: '٣ س',
        ),
        AppNotification(
          id: 4, group: NotifGroup.earlier, tone: NotifTone.amber, icon: 'star', unread: false,
          title: 'New 5-star review', body: 'Mariam Al Hosani rated your pistachio cake 5 stars.',
          titleAr: 'تقييم جديد بـ5 نجوم', bodyAr: 'قيّمت مريم الحوسني كيكة الفستق بـ5 نجوم.',
          time: 'Yesterday', timeAr: 'أمس',
        ),
        AppNotification(
          id: 5, group: NotifGroup.earlier, tone: NotifTone.green, icon: 'checkCircle', unread: false,
          title: 'Order delivered', body: 'Order #1038 was delivered successfully.',
          titleAr: 'تم توصيل الطلب', bodyAr: 'تم توصيل الطلب #1038 بنجاح.',
          time: 'Yesterday', timeAr: 'أمس',
        ),
      ];
}
