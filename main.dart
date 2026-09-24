import 'package:flutter/material.dart';

void main() => runApp(const KolithaOsuNiwasaApp());

class Product {
  final String nameSi, nameEn, categorySi, categoryEn, description;
  final double price;
  final String pack;
  final String emoji;
  Product({
    required this.nameSi, required this.nameEn,
    required this.categorySi, required this.categoryEn,
    required this.description, required this.price,
    required this.pack, required this.emoji,
  });
}

final products = <Product>[
  Product(nameSi:'නීලවරා කුඩු', nameEn:'Nilavara Herbal Powder',
    categorySi:'චූර්ණ', categoryEn:'Powders',
    description:'නිෂ්පාදන ලේබලයේ සඳහන් භාවිත උපදෙස් අනුව පමණක් භාවිත කරන්න.',
    price:750, pack:'100 g', emoji:'🌿'),
  Product(nameSi:'ඖෂධීය තෙල්', nameEn:'Herbal Oil',
    categorySi:'ඖෂධීය තෙල්', categoryEn:'Herbal Oils',
    description:'නිෂ්පාදකයාගේ ලේබලය සහ අවවාද කියවා භාවිත කරන්න.',
    price:1250, pack:'100 ml', emoji:'🫙'),
  Product(nameSi:'කොත්තමල්ලි', nameEn:'Coriander Herbal Product',
    categorySi:'සාම්ප්‍රදායික නිෂ්පාදන', categoryEn:'Traditional Products',
    description:'ආහාර/හර්බල් නිෂ්පාදනයක් ලෙස ලේබලයේ තොරතුරු පරීක්ෂා කරන්න.',
    price:650, pack:'200 g', emoji:'🌱'),
  Product(nameSi:'හර්බල් සබන්', nameEn:'Herbal Soap',
    categorySi:'පෞද්ගලික සත්කාර', categoryEn:'Personal Care',
    description:'සමේ භාවිතයට පෙර නිෂ්පාදන ලේබලයේ උපදෙස් බලන්න.',
    price:450, pack:'1 bar', emoji:'🧼'),
];

class CartModel extends ChangeNotifier {
  final Map<Product,int> items = {};
  void add(Product p) { items[p] = (items[p] ?? 0) + 1; notifyListeners(); }
  void remove(Product p) {
    if (!items.containsKey(p)) return;
    if (items[p] == 1) items.remove(p); else items[p] = items[p]! - 1;
    notifyListeners();
  }
  int get count => items.values.fold(0,(a,b)=>a+b);
  double get subtotal => items.entries.fold(0,(s,e)=>s + e.key.price*e.value);
}
final cart = CartModel();

class KolithaOsuNiwasaApp extends StatefulWidget {
  const KolithaOsuNiwasaApp({super.key});
  @override State<KolithaOsuNiwasaApp> createState()=>_AppState();
}
class _AppState extends State<KolithaOsuNiwasaApp> {
  bool si = true;
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner:false,
    title:'කෝලිත ඔසු නිවස',
    theme: ThemeData(useMaterial3:true, colorSchemeSeed:const Color(0xFF176B35),
      scaffoldBackgroundColor:const Color(0xFFF7F7F0), fontFamily:'sans'),
    home: Home(si:si,onLanguage:()=>setState(()=>si=!si)),
  );
}

class Home extends StatefulWidget {
  final bool si; final VoidCallback onLanguage;
  const Home({super.key,required this.si,required this.onLanguage});
  @override State<Home> createState()=>_HomeState();
}
class _HomeState extends State<Home> {
  int index=0;
  @override Widget build(BuildContext context){
    final pages=[
      _home(context), CategoriesPage(si:widget.si), CartPage(si:widget.si),
      OrdersPage(si:widget.si), ProfilePage(si:widget.si)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('කෝලිත ඔසු නිවස',style:TextStyle(fontWeight:FontWeight.w800)),
          Text('Kolitha Osu Niwasa',style:TextStyle(fontSize:12,color:Colors.grey[700]))
        ]),
        actions:[TextButton(onPressed:widget.onLanguage,child:Text(widget.si?'EN':'සිං'))],
      ),
      body: pages[index],
      bottomNavigationBar:NavigationBar(selectedIndex:index,onDestinationSelected:(i)=>setState(()=>index=i),
        destinations:[
          NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:widget.si?'මුල් පිටුව':'Home'),
          NavigationDestination(icon:Icon(Icons.grid_view),label:widget.si?'වර්ග':'Categories'),
          NavigationDestination(icon:Badge(label:Text('${cart.count}'),isLabelVisible:cart.count>0,child:Icon(Icons.shopping_cart_outlined)),label:widget.si?'කාට්':'Cart'),
          NavigationDestination(icon:Icon(Icons.receipt_long_outlined),label:widget.si?'ඇණවුම්':'Orders'),
          NavigationDestination(icon:Icon(Icons.person_outline),label:widget.si?'මගේ ගිණුම':'Profile'),
        ]),
    );
  }
  Widget _home(BuildContext c)=>ListView(padding:const EdgeInsets.all(16),children:[
    Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(
      gradient:const LinearGradient(colors:[Color(0xFFEAF5E7),Color(0xFFD9EFD7)]),
      borderRadius:BorderRadius.circular(24)),child:Row(children:[
        Image.asset('assets/logo.svg',width:72,height:72),
        const SizedBox(width:16),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(widget.si?'ස්වාභාවික නිෂ්පාදන':'Natural Herbal Products',style:const TextStyle(fontSize:22,fontWeight:FontWeight.w800)),
          const SizedBox(height:6),
          Text(widget.si?'ශ්‍රී ලංකාව පුරා Cash on Delivery':'Islandwide Cash on Delivery'),
        ]))
      ])),
    const SizedBox(height:16),
    TextField(decoration:InputDecoration(prefixIcon:const Icon(Icons.search),hintText:widget.si?'භාණ්ඩ සොයන්න':'Search products',filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none))),
    const SizedBox(height:20),
    Text(widget.si?'ප්‍රධාන වර්ග':'Categories',style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800)),
    const SizedBox(height:12),
    Wrap(spacing:10,runSpacing:10,children:['🌿 ${widget.si?"ඖෂධ":"Medicines"}','🫙 ${widget.si?"තෙල්":"Oils"}','🥣 ${widget.si?"චූර්ණ":"Powders"}','🧼 ${widget.si?"පෞද්ගලික සත්කාර":"Personal Care"}'].map((x)=>Chip(label:Text(x))).toList()),
    const SizedBox(height:24),
    Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
      Text(widget.si?'ජනප්‍රිය නිෂ්පාදන':'Popular Products',style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800)),
      TextButton(onPressed:(){},child:Text(widget.si?'සියල්ල':'See all'))
    ]),
    ...products.map((p)=>ProductCard(p:p,si:widget.si,onAdd:()=>setState(()=>cart.add(p)))),
  ]);
}

class ProductCard extends StatelessWidget{
  final Product p; final bool si; final VoidCallback onAdd;
  const ProductCard({super.key,required this.p,required this.si,required this.onAdd});
  @override Widget build(BuildContext c)=>Card(margin:const EdgeInsets.only(bottom:12),child:ListTile(
    leading:Container(width:56,height:56,alignment:Alignment.center,decoration:BoxDecoration(color:const Color(0xFFEAF5E7),borderRadius:BorderRadius.circular(14)),child:Text(p.emoji,style:const TextStyle(fontSize:28))),
    title:Text(si?p.nameSi:p.nameEn,style:const TextStyle(fontWeight:FontWeight.w700)),
    subtitle:Text('Rs. ${p.price.toStringAsFixed(0)} • ${p.pack}'),
    trailing:IconButton(onPressed:onAdd,icon:const Icon(Icons.add_shopping_cart)),
    onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>ProductPage(p:p,si:si,onAdd:onAdd))),
  ));
}

class ProductPage extends StatelessWidget{
  final Product p; final bool si; final VoidCallback onAdd;
  const ProductPage({super.key,required this.p,required this.si,required this.onAdd});
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(si?p.nameSi:p.nameEn)),body:ListView(padding:const EdgeInsets.all(20),children:[
    Container(height:220,alignment:Alignment.center,decoration:BoxDecoration(color:const Color(0xFFEAF5E7),borderRadius:BorderRadius.circular(24)),child:Text(p.emoji,style:const TextStyle(fontSize:100))),
    const SizedBox(height:20),Text(si?p.nameSi:p.nameEn,style:const TextStyle(fontSize:26,fontWeight:FontWeight.w800)),
    const SizedBox(height:8),Text('Rs. ${p.price.toStringAsFixed(0)}',style:const TextStyle(fontSize:22,fontWeight:FontWeight.w700)),
    const SizedBox(height:12),Text('${si?"ප්‍රමාණය":"Pack size"}: ${p.pack}'),
    const SizedBox(height:18),Text(si?'නිෂ්පාදන තොරතුරු':'Product information',style:const TextStyle(fontSize:18,fontWeight:FontWeight.w700)),
    const SizedBox(height:8),Text(p.description),
    const SizedBox(height:28),FilledButton.icon(onPressed:(){onAdd();ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text(si?'කාට් එකට එකතු කළා':'Added to cart')));},icon:const Icon(Icons.shopping_cart),label:Text(si?'කාට් එකට එකතු කරන්න':'Add to cart'))
  ]));
}

class CategoriesPage extends StatelessWidget{
  final bool si; const CategoriesPage({super.key,required this.si});
  @override Widget build(BuildContext c)=>GridView.count(padding:const EdgeInsets.all(16),crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,children:[
    '🌿 ${si?"ආයුර්වේද ඖෂධ":"Ayurvedic Medicines"}','🫙 ${si?"ඖෂධීය තෙල්":"Herbal Oils"}','🥣 ${si?"චූර්ණ":"Powders"}','🌱 ${si?"හර්බල් නිෂ්පාදන":"Herbal Products"}','🧼 ${si?"පෞද්ගලික සත්කාර":"Personal Care"}','🍵 ${si?"ඖෂධීය ආහාර":"Herbal Foods"}'
  ].map((x)=>Card(child:Center(child:Padding(padding:const EdgeInsets.all(10),child:Text(x,textAlign:TextAlign.center,style:const TextStyle(fontWeight:FontWeight.w700)))))).toList());
}

class CartPage extends StatefulWidget{
  final bool si; const CartPage({super.key,required this.si});
  @override State<CartPage> createState()=>_CartPageState();
}
class _CartPageState extends State<CartPage>{
  @override Widget build(BuildContext c)=>AnimatedBuilder(animation:cart,builder:(_,__)=>ListView(padding:const EdgeInsets.all(16),children:[
    Text(widget.si?'මගේ කාට්':'My Cart',style:const TextStyle(fontSize:26,fontWeight:FontWeight.w800)),
    const SizedBox(height:16),
    if(cart.items.isEmpty) Center(child:Padding(padding:const EdgeInsets.all(60),child:Text(widget.si?'කාට් එක හිස්':'Your cart is empty')))
    else ...cart.items.entries.map((e)=>Card(child:ListTile(title:Text(widget.si?e.key.nameSi:e.key.nameEn),subtitle:Text('Rs. ${e.key.price.toStringAsFixed(0)} × ${e.value}'),trailing:Row(mainAxisSize:MainAxisSize.min,children:[
      IconButton(onPressed:()=>setState(()=>cart.remove(e.key)),icon:const Icon(Icons.remove_circle_outline)),
      Text('${e.value}'),
      IconButton(onPressed:()=>setState(()=>cart.add(e.key)),icon:const Icon(Icons.add_circle_outline)),
    ])))),
    if(cart.items.isNotEmpty)...[
      const Divider(height:30),Text('${widget.si?"මුළු එකතුව":"Subtotal"}: Rs. ${cart.subtotal.toStringAsFixed(0)}',style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800)),
      const SizedBox(height:16),FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>CheckoutPage(si:widget.si))),child:Text(widget.si?'Checkout වෙත යන්න':'Proceed to Checkout'))
    ]
  ]));
}

class CheckoutPage extends StatefulWidget{
  final bool si; const CheckoutPage({super.key,required this.si});
  @override State<CheckoutPage> createState()=>_CheckoutPageState();
}
class _CheckoutPageState extends State<CheckoutPage>{
  final name=TextEditingController(), phone=TextEditingController(), address=TextEditingController(), city=TextEditingController();
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(widget.si?'Checkout':'Checkout')),body:ListView(padding:const EdgeInsets.all(16),children:[
    Text(widget.si?'බෙදාහැරීමේ විස්තර':'Delivery details',style:const TextStyle(fontSize:21,fontWeight:FontWeight.w800)),
    const SizedBox(height:12),
    for(final x in [[name,widget.si?'සම්පූර්ණ නම':'Full name'],[phone,widget.si?'දුරකථන අංකය':'Mobile number'],[address,widget.si?'ලිපිනය':'Address'],[city,widget.si?'නගරය':'City']]) Padding(padding:const EdgeInsets.only(bottom:12),child:TextField(controller:x[0] as TextEditingController,decoration:InputDecoration(labelText:x[1] as String,border:const OutlineInputBorder()))),
    Card(child:ListTile(leading:const Icon(Icons.payments_outlined),title:Text(widget.si?'මුදල් ලබා දෙන විට ගෙවීම':'Cash on Delivery'),subtitle:Text(widget.si?'භාණ්ඩය ලැබුණු විට මුදල් ගෙවන්න':'Pay when you receive your order'))),
    const SizedBox(height:12),Text('${widget.si?"Order total":"Total"}: Rs. ${cart.subtotal.toStringAsFixed(0)}',style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800)),
    const SizedBox(height:18),FilledButton(onPressed:(){
      showDialog(context:c,builder:(_)=>AlertDialog(title:Text(widget.si?'ඇණවුම සාර්ථකයි':'Order placed'),content:Text(widget.si?'ඔබගේ COD ඇණවුම ලැබුණා. Order ID: KN-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}':'Your COD order has been received.'),actions:[TextButton(onPressed:(){cart.items.clear();cart.notifyListeners();Navigator.popUntil(c,(r)=>r.isFirst);},child:Text(widget.si?'හරි':'OK'))]));
    },child:Text(widget.si?'ඇණවුම තහවුරු කරන්න':'Place order'))
  ]));
}

class OrdersPage extends StatelessWidget{
  final bool si; const OrdersPage({super.key,required this.si});
  @override Widget build(BuildContext c)=>ListView(padding:const EdgeInsets.all(16),children:[
    Text(si?'මගේ ඇණවුම්':'My Orders',style:const TextStyle(fontSize:26,fontWeight:FontWeight.w800)),
    const SizedBox(height:16),Card(child:ListTile(leading:const Icon(Icons.local_shipping_outlined),title:Text(si?'නව ඇණවුම් මෙතැන පෙන්වයි':'Your orders will appear here'),subtitle:Text(si?'තහවුරු කළා → සකස් කළා → යැව්වා → ලබා දුන්නා':'Confirmed → Packed → Shipped → Delivered')))
  ]);
}

class ProfilePage extends StatelessWidget{
  final bool si; const ProfilePage({super.key,required this.si});
  @override Widget build(BuildContext c)=>ListView(padding:const EdgeInsets.all(16),children:[
    const CircleAvatar(radius:42,child:Icon(Icons.person,size:44)),const SizedBox(height:12),
    const Center(child:Text('කෝලිත ඔසු නිවස',style:TextStyle(fontSize:22,fontWeight:FontWeight.w800))),
    const SizedBox(height:24),
    for(final x in [si?'මගේ ඇණවුම්':'My Orders',si?'ලිපින':'Addresses',si?'උදව් සහ සහාය':'Help & Support',si?'සැකසුම්':'Settings'])
      Card(child:ListTile(title:Text(x),trailing:const Icon(Icons.chevron_right)))
  ]);
}
