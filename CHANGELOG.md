# Changelog

## 1.3.0

- Removed `ostruct` from codebase. Replaced data structures returned by the library with the `Struct` defined underneath. This might be a breaking change if you used OpenStruct and extended it by adding your own fields in your applications.
```rb
SearchResult = Struct.new(:name, :regon, :province, :district, :community, :city, :zip_code, :street, :street_number, :house_number, :street_address, :type, :silos_id, :type_desc, :silos_desc, :report :post_city)
```
