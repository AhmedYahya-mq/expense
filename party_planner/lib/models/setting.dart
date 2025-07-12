class Setting {
  String? key;
  String? value;

  Setting({this.key, this.value});

  Setting.fromJson(Map<String, dynamic> json) {
    key = json.keys.first;
    value = json[key];
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}
