import 'package:get/get.dart';

import '../modules/cekkebugaran/bindings/cekkebugaran_binding.dart';
import '../modules/cekkebugaran/views/cekkebugaran_view.dart';
import '../modules/detailgunung/bindings/detailgunung_binding.dart';
import '../modules/detailgunung/views/detailgunung_view.dart';
import '../modules/detailjalur/bindings/detailjalur_binding.dart';
import '../modules/detailjalur/views/detailjalur_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/listgunung/bindings/listgunung_binding.dart';
import '../modules/listgunung/views/listgunung_view.dart';
import '../modules/listlatihan/bindings/listlatihan_binding.dart';
import '../modules/listlatihan/views/listlatihan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/progres/bindings/progres_binding.dart';
import '../modules/progres/views/progres_view.dart';
import '../modules/quesioner/bindings/quesioner_binding.dart';
import '../modules/quesioner/views/quesioner_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/ubahpassword/bindings/ubahpassword_binding.dart';
import '../modules/ubahpassword/views/ubahpassword_view.dart';
import '../modules/ubahprofile/bindings/ubahprofile_binding.dart';
import '../modules/ubahprofile/views/ubahprofile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.LISTLATIHAN,
      page: () => const ListlatihanView(),
      binding: ListlatihanBinding(),
    ),
    GetPage(
      name: _Paths.PROGRES,
      page: () => const ProgresView(),
      binding: ProgresBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.LISTGUNUNG,
      page: () => const ListgunungView(),
      binding: ListgunungBinding(),
    ),
    GetPage(
      name: _Paths.DETAILGUNUNG,
      page: () => const DetailgunungView(),
      binding: DetailgunungBinding(),
    ),
    GetPage(
      name: _Paths.DETAILJALUR,
      page: () => const DetailjalurView(),
      binding: DetailjalurBinding(),
    ),
    GetPage(
      name: _Paths.CEKKEBUGARAN,
      page: () => const CekkebugaranView(),
      binding: CekkebugaranBinding(),
    ),
    GetPage(
      name: _Paths.UBAHPROFILE,
      page: () => const UbahprofileView(),
      binding: UbahprofileBinding(),
    ),
    GetPage(
      name: _Paths.UBAHPASSWORD,
      page: () => const UbahpasswordView(),
      binding: UbahpasswordBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.QUESIONER,
      page: () => const QuesionerView(),
      binding: QuesionerBinding(),
    ),
  ];
}
