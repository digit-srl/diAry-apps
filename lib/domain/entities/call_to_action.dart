class CallToAction {
  DateTime lastCheckTimestamp;
  List<DailyHash> activities;

  CallToAction({this.lastCheckTimestamp, this.activities});

  CallToAction.fromJson(Map<String, dynamic> json) {
    lastCheckTimestamp = json['lastCheckTimestamp'] != null
        ? DateTime.tryParse(json['lastCheckTimestamp'])
        : null;
    if (json['activities'] != null) {
      activities = new List<DailyHash>();
      json['activities'].forEach((v) {
        activities.add(new DailyHash.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastCheckTimestamp'] = this.lastCheckTimestamp?.toIso8601String();
    if (this.activities != null) {
      data['activities'] = this.activities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyHash {
  DateTime date;
  List<String> hashes;

  DailyHash({this.date, this.hashes});

  DailyHash.fromJson(Map<String, dynamic> json) {
    date = json['date'] != null ? DateTime.tryParse(json['date']) : null;
    hashes = json['hashes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date?.toIso8601String();
    data['hashes'] = this.hashes;
    return data;
  }
}
