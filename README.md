# RealmSwift-Alamofire

Note: 


https://blog.hyphe.me/realm-and-alamofire-in-a-effective-harmony/ 


https://www.appcoda.com/realm-database-swift/


#Realm doesn't support polymorphic queries yet.

So you would need to query for both object types separately.

let cat = realm.objects(Cat)
let dog = realm.objects(Dog)
Depending on your use-case, you could just pull them all in memory and append them both to an array of [Object] and then simply sort that array. That would look like below:

var pets = [Object]()
pets += dogs.map { $0 as Pet }
pets += cats.map { $0 as Pet }
var sortedPets = pets.sort { $0.date.compare($1.date) == .OrderedAscending }

http://stackoverflow.com/questions/32809907/merge-inheritance-realm-objects-together
