import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'shopclasses.dart';

Map<String,int> cartItems = Map<String,int>();

Future<List<CatalogItem>> availableItems;

Future<List<CatalogItem>> getItemsInCategory(String categoryId) async {
  print(categoryId);
  /*
Map<String,String> hdrs = {
  'Authorization':'Bearer EAAAEBmsE3Nfn-dJp1dQOzUQVf2oIaK4CECjbWc2GCJPuTSgZLSMhHKn1c0jN_I_',
  'Accept':'application/json'
};
  var topost = '{"object_types": ["ITEM"],"query": {"exact_query": {"attribute_name": "category_id","attribute_value": "categoryId"}},"limit": 100}';
  final response = await http.post('https://connect.squareup.com/v2/catalog/search',headers: hdrs,body:topost);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return CatalogItem.listfromJson(json.decode(response.body)['objects']);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
   */
  List<CatalogItem> rv = [];

  rv.add(CatalogItem(name:"dummy 1",description:"only a test",realId: "SKUTEST 1"));
  rv[0].minPrice = 6.50;
  rv[0].maxPrice = 10.24;
  rv.add(CatalogItem(name:"dummy 2",description:"another test",realId: "SKUTEST 2"));
  rv[1].minPrice = 6.24;
  rv[1].maxPrice = 6.24;

  return rv;
}

Future<List<Category>> fetchPost() async {
/*
  Request rq = Request("GET",Uri(scheme:"https",host:"connect.squareup.com", path: "/v2/catalog/list?types=category"));
  rq.headers['Authorization'] = 'Bearer EAAAEBmsE3Nfn-dJp1dQOzUQVf2oIaK4CECjbWc2GCJPuTSgZLSMhHKn1c0jN_I_';
  rq.headers['Accept'] ='application/json';
  */
Map<String,String> hdrs = {
  'Authorization':'Bearer EAAAEBmsE3Nfn-dJp1dQOzUQVf2oIaK4CECjbWc2GCJPuTSgZLSMhHKn1c0jN_I_',
  'Accept':'application/json'
};
 // final response =
//  await http.get('https://jsonplaceholder.typicode.com/posts/1');
  //final response = await http.get('https://connect.squareup.com/v2/catalog/list?types=category',headers: hdrs);

  /*
  var topost = '{
      "object_types": [
  "ITEM"
  ],
  "query": {
  "prefix_query": {
  "attribute_name": "name",
  "attribute_prefix": "Experimental"
  }
  },
  "limit": 100
}';
*/
  List<Category> rv = [
     Category(name:"Experimental DS",id:1,realId:"DEL63IYTIH34N7PTSXK2OEI2"),

     Category(name:"Experimental DS 2",id:2,realId:"JPNMJPWHUKDQLMI5ARZVQUVM"),

    Category(name:"Experimental DS 3",id:3,realId:"3ZHJMM3FJW63Y7UGJW6N33CJ"),
  ];

  return rv;
  /*
  //works but deferred
  var topost = '{"object_types": ["CATEGORY"],"query": {"prefix_query": {"attribute_name": "name","attribute_prefix": "Experimental"}},"limit": 100}';
  final response = await http.post('https://connect.squareup.com/v2/catalog/search',headers: hdrs,body:topost);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Category.listfromJson(json.decode(response.body)['objects']);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
  */
}

void addToCartMain(String realId) {
  int qty = 1;
  if(cartItems.containsKey(realId))
    {
      qty = cartItems[realId] + 1;
    }
  cartItems[realId] = qty;
}

//TODO: hold off on fetchingCategories until the user says so
void main() => runApp(MyApp(categories: fetchPost()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<List<Category>> categories;
  

  MyApp({Key key,this.categories}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    if(isIOS())
    {
     return CupertinoApp(
        theme:CupertinoThemeData(
          primaryColor: Colors.blue
        ),
       home:AppShell(title: 'Natural Conduit',categories: this.categories),
     );
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: AppShell(title: 'Natural Conduit',categories: this.categories),

    );

  }

  getMenu(BuildContext whatcontext) {
    Widget rv = PopupMenuButton(
      onSelected: (String result) { print(result); },
        itemBuilder: (BuildContext context){

        }
    );
    return [rv];
  }

}

/*
class MyAppBar extends StatefulWidget {
  var categories;

  MyAppBar({Key key,this.categories}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
@override
Widget build(BuildContext context) {
  return  AppBar(
    title: Text('Fetch Data Example'),
  );
}

}
*/

class AppShell extends StatefulWidget {
  final categories;
  AppShell({Key key, this.title,this.categories}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AppShellState createState() => _AppShellState();

  void fetchItemsInCategory(String aha) {
    availableItems = getItemsInCategory(aha);
  }
}

class _AppShellState extends State<AppShell> {
  bool didSearch=false;

  @override
  Widget build(BuildContext context) {
     return FutureBuilder<List<Category>>(
       future:widget.categories,
         builder: (context, snapshot) {
           if (snapshot.hasData) {
             if(isIOS()) {
               List<Widget> categoryActions = [];
               for(int i=0;i<snapshot.data.length;i++)
               {
                 categoryActions.add(
                     CupertinoActionSheetAction(
                     onPressed:() {
                          Navigator.pop(context,snapshot.data[i].realId);
                     },
                     child:Text(snapshot.data[i].name)
                 )
                 );
               }

               List<Widget> central = [
                 FutureBuilder<List<CatalogItem>>(
                 future:availableItems,
                 builder: (context,snapshot) {
                   if (!didSearch) {
                     return Text("Please select from the categories",);
                   }
                   if (snapshot.hasData) {
                     List<Widget> rv = [];
                     for (int j = 0; j < snapshot.data.length; j++) {
                       if (j > 0) {
                         rv.add(Divider());
                       }
                       rv.add(ItemDisplay(snapshot.data[j], MediaQuery
                           .of(context)
                           .size
                           .width, this));
                     }
                     return ListView(children: rv);
                   }
                   if (snapshot.hasError) {
                     return Text("${snapshot.error}");
                   }
                   //must be still going, so..
                   return CircularProgressIndicator();
           }
                 )
               ]
               ;
               /*
               if(didSearch)
                 {
                   central.add(

                       CupertinoActionSheet(
                           title:Text("Choose category"),
                           cancelButton: CupertinoActionSheetAction(
                             onPressed: () {},
                             child:Text("Cancel"),
                           ),
                           actions:categoryActions
                       )
                   );
                 }
               */
               return CupertinoPageScaffold(
                   navigationBar:CupertinoNavigationBar(
                     leading:CartButton(),
                     middle:Text(widget.title),
                     trailing:CupertinoButton(
                       onPressed:(){
                         showCategoryMenu(context,CupertinoActionSheet(
                             title:Text("Choose a category"),
                           actions: categoryActions,
                           cancelButton: CupertinoActionSheetAction(
                            child: const Text('Cancel'),
                             isDefaultAction: true,
                             onPressed: () {
                                 Navigator.pop(context, null);
                             }
                         )
                         )
                         );
                       },
                       child:Text("Shop"),

                     ),

                   ),
                    child: Center(
                   // Center is a layout widget. It takes a single child and positions it
                   // in the middle of the parent.
                   //child: Text("Choose from the menu of categories")
                     child:central[0]

                 )


               );
             }
             /*done only if not iOS*/
             return Scaffold(
                 appBar: AppBar(
                   // Here we take the value from the MyHomePage object that was created by
                   // the App.build method, and use it to set our appbar title.
                   title: Text(widget.title),
                   actions:[
                     CartButton(),
                     PopupMenuButton<String>(
                         onSelected: (aha){
                           setState((){
                             didSearch = true;
                           widget.fetchItemsInCategory(aha);
                           }) ;

                         },
                         itemBuilder: (BuildContext localcontext){
                       List<PopupMenuItem<String>> rv = [];
                       for(int j=0;j<snapshot.data.length;j++)
                         {
                           rv.add(
                             PopupMenuItem<String>(value:snapshot.data[j].realId, child:Text(snapshot.data[j].name))
                           );
                         }
                       return rv;
                     })
                   ]
                 ),
                 body: Center(
                   // Center is a layout widget. It takes a single child and positions it
                   // in the middle of the parent.
                     //child: Text("Choose from the menu of categories")
                   child:FutureBuilder<List<CatalogItem>>(
                     future:availableItems,
                     builder: (context,snapshot) {
                       if(!didSearch)
                         {
                           return Text("Please select from the categories");
                         }
                       if(snapshot.hasData)
                         {
                           List<Widget> rv = [];
                           for(int j=0;j<snapshot.data.length;j++)
                           {
                             if(j>0)
                               {
                                 rv.add(Divider());
                               }
                              rv.add(ItemDisplay(snapshot.data[j],MediaQuery.of(context).size.width,this));

                           }
                           return ListView(children:rv);
                         }
                       if(snapshot.hasError)
                       {
                          return Text("${snapshot.error}");
                       }
                       //must be still going, so..
                       return CircularProgressIndicator();
                     }
                   )
                 )
             );
           } else if (snapshot.hasError) {
             if(isIOS())
             {
               return CupertinoPageScaffold(
                 navigationBar:CupertinoNavigationBar(
                     leading:CartButton(),
                     middle:Text(widget.title)
                 ),
                 child:Center(
                   // Center is a layout widget. It takes a single child and positions it
                   // in the middle of the parent.
                     child: Text("${snapshot.error}")
                 )
               );
             }
             /*done only if not iOS*/
             return Scaffold(
                 appBar: AppBar(
                   // Here we take the value from the MyHomePage object that was created by
                   // the App.build method, and use it to set our appbar title.
                   title: Text(widget.title),
                   actions:[
                     CartButton()
                   ]
                 ),
                 body: Center(
                   // Center is a layout widget. It takes a single child and positions it
                   // in the middle of the parent.
                     child: Text("${snapshot.error}")
                 )
             );
           }

           // By default, show a loading spinner

           if(isIOS()){
             return CupertinoPageScaffold(
                 navigationBar:CupertinoNavigationBar(
                     leading:CartButton(),
                     middle:Text(widget.title)
                 ),
                 child:Center(
                   // Center is a layout widget. It takes a single child and positions it
                   // in the middle of the parent.
                     child: CircularProgressIndicator()
                 )
             );
           }
           /*done only if not iOS*/
           return Scaffold(
               appBar: AppBar(
                 // Here we take the value from the MyHomePage object that was created by
                 // the App.build method, and use it to set our appbar title.
                 title: Text(widget.title),
                 actions:[CartButton()]
               ),
               body: Center(
               // Center is a layout widget. It takes a single child and positions it
               // in the middle of the parent.
               child: CircularProgressIndicator()
               )
           );
           //
           //return CircularProgressIndicator();
         }
     );
  }

  void addToCart(String realId) {
    setState((){
      addToCartMain(realId);
    });
  }

  void showCategoryMenu(BuildContext context, Widget child) {
    showCupertinoModalPopup<String>(
      context: context,
      builder:(BuildContext context) => child
    ).then((String value) {
      if(value != null) {
        setState((){
          didSearch = true;
          widget.fetchItemsInCategory(value);
        });
      }
    });
  }

}

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int numItems = 0;
    cartItems.forEach((key,value){
      numItems += value;
    });
    if(isIOS()){
      return CupertinoButton(
        onPressed: (){},
        child:Row(children:[Icon(CupertinoIcons.shopping_cart),Text("$numItems")])
      );
    }
    return MaterialButton(
      onPressed: (){},
      child: Row(children:[Icon(Icons.shopping_cart),Text("$numItems")]),
    ) ; 
  }
  
}

class ItemDisplay extends StatelessWidget {
  final CatalogItem item;

  final double square;

  final _AppShellState _chief;
  ItemDisplay(this.item, this.square, this._chief,{Key key}):super(key:key) ;

  Widget build(BuildContext context) {
    List<Widget> rv =[];
    //var imgHolder = Container(width:context.size.width,height:context.size.width);
    Widget imgHolder;
    if(item.imgUrl!=null && item.imgUrl.isNotEmpty)
      {

        imgHolder = (
          Image.network(item.imgUrl)
        );
      }
    else
      {
        imgHolder = (
          Text("Image not Available")
        );
      }
    //var chosen = MediaQuery.of(context).size.width/2;
    rv.add(
        Container(child:imgHolder,width:square,height:square,alignment: Alignment.center,color: Color.fromRGBO(0, 160, 32, .3))
      //
    );

    rv.add(
        Text(item.name)
    ) ;
    rv.add(
        Text(item.description)
    );
    if(item.maxPrice - item.minPrice >= 0.01)
    {

     rv.add(
      Text("\$${item.minPrice.toStringAsFixed(2)} - \$${item.maxPrice.toStringAsFixed(2)}",textAlign: TextAlign.center)
     );
    }
    else
      {
        rv.add(
            Text("\$${item.minPrice.toStringAsFixed(2)}",textAlign: TextAlign.center)
        );
      }
      rv.add(
        MaterialButton(
          onPressed:(){_chief.addToCart(item.realId);},
          child:Text("Add to Cart"),
          color:Color.fromRGBO(255, 180, 90, .25)
        )
      );
    return Column(children:rv);
  }
}




/*
home: Scaffold(
        appBar: MyAppBar(categories: this.categories),
        body: Center(
          child: FutureBuilder<List<Category>>(
            future: categories,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Text> rv = [];
                for(int i=0;i<snapshot.data.length;i++)
                  {
                    rv.add(Text(snapshot.data[i].name));
                  }
                return Column(children: rv);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
 */
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),


    );
  }
}
