class GetIpCountry {
 late String status;
 late String country;
 late String countryCode;
 late String region;
 late String regionName;
 late String city;
 late String zip;
 late double lat;
 late double lon;
 late String timezone;
 late String isp;
 late String org;
 late String as;
 late String query;

  GetIpCountry(
      {required this.status,
        required this.country,
        required this.countryCode,
        required this.region,
        required this.regionName,
        required this.city,
        required this.zip,
        required this.lat,
        required this.lon,
        required this.timezone,
        required this.isp,
        required this.org,
        required this.as,
        required this.query});

  GetIpCountry.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? '';
    country = json['country'] ?? '';
    countryCode = json['countryCode'] ?? '';
    region = json['region'] ?? '';
    regionName = json['regionName'] ?? '';
    city = json['city'] ?? '';
    zip = json['zip'] ?? '';
    lat = json['lat'] ?? '';
    lon = json['lon'] ?? '';
    timezone = json['timezone'] ?? '';
    isp = json['isp'] ?? '';
    org = json['org' ?? ''];
    as = json['as'] ?? '';
    query = json['query'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['country'] = country;
    data['countryCode'] = countryCode;
    data['region'] = region;
    data['regionName'] = regionName;
    data['city'] = city;
    data['zip'] = zip;
    data['lat'] = lat;
    data['lon'] = lon;
    data['timezone'] = timezone;
    data['isp'] = isp;
    data['org'] = org;
    data['as'] = as;
    data['query'] = query;
    return data;
  }
}