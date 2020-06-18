import 'package:brainhouse_i/view/activity/expert/expert_dashboard_screen.dart';
import 'package:brainhouse_i/view/activity/expert/expert_my_profile_nav.dart';
import 'package:brainhouse_i/view/activity/expert/expert_ticket_tab_bar.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors = <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor;
}

class ClassBuilder {
  static void registerClasses() {
    register<ExpertDashboard>(() => ExpertDashboard());
    register<ExpertMyProfile>(() => ExpertMyProfile());
    register<Ticket_Tab_bar>(() => Ticket_Tab_bar());
  }

  static dynamic fromString(String type) {
    return _constructors[type]();
  }
}