class Category {

  final int id;
  final String realId;
  final String name;

  Category({this.name, this.id, this.realId});

  static List<Category> listfromJson(List<dynamic> json)
  {
    List<Category> rv = [];
    for(int i=0;i < json.length; i++)
    {
      rv.add(
          Category(
          name: json[i]['category_data']['name'],
          id: json[i]['cat_id'],
              realId:json[i]['id']
          )
      );
    }

    return rv;
  }
}

class CatalogItem {
  final String realId;
  final String name;

  final String description;

  double maxPrice;
  double minPrice;

  String sku;
  String imgUrl;

  CatalogItem({this.name,this.realId, this.description});

  static List<CatalogItem> listfromJson(List<dynamic> json)
  {
    List<CatalogItem> rv = [];
    for(int i=0;i < json.length; i++)
    {
      var gotItem =
      CatalogItem(
          name: json[i]['item_data']['name'],
          realId:json[i]['id'],
          description: json[i]['item_data']['description']
      );
      var minprice = 1000000.00;
      var maxprice = 0.00;
      for(int j=0;j<json[i]['item_data']['variations'].length;j++)
        {
          var variation = json[i]['item_data']['variations'][j];
          if(j==0) {
            gotItem.sku = variation['item_variation_data']['sku'];
          }
          var maybeprice = int.parse(variation['item_variation_data']['price_money']['amount'])/100;
          if(maybeprice <minprice)
            {
              minprice = maybeprice;
            }
          if(maybeprice > maxprice)
            {
              maxprice = maybeprice;
            }
        }
      gotItem.minPrice = minprice;
      gotItem.maxPrice = maxprice;

      if(json[i]['image_id'])
        {
          gotItem.imgUrl=json[i]['image_id'];
        }

      rv.add(
          gotItem
      );
    }

    return rv;
  }
}