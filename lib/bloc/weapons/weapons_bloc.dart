import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/enums/sort_direction_type.dart';
import '../../common/enums/weapon_filter_type.dart';
import '../../common/enums/weapon_type.dart';
import '../../models/models.dart';
import '../../services/genshing_service.dart';

part 'weapons_bloc.freezed.dart';
part 'weapons_event.dart';
part 'weapons_state.dart';

class WeaponsBloc extends Bloc<WeaponsEvent, WeaponsState> {
  final GenshinService _genshinService;
  WeaponsBloc(this._genshinService) : super(const WeaponsState.loading());

  _LoadedState get currentState => state as _LoadedState;

  @override
  Stream<WeaponsState> mapEventToState(
    WeaponsEvent event,
  ) async* {
    final s = event.map(
      init: (_) => _buildInitialState(),
      weaponFilterTypeChanged: (e) => currentState.copyWith.call(tempWeaponFilterType: e.filterType),
      rarityChanged: (e) => currentState.copyWith.call(tempRarity: e.rarity),
      sortDirectionTypeChanged: (e) => currentState.copyWith.call(tempSortDirectionType: e.sortDirectionType),
      weaponTypeChanged: (e) {
        var types = <WeaponType>[];
        if (currentState.tempWeaponTypes.contains(e.weaponType)) {
          types = currentState.tempWeaponTypes.where((t) => t != e.weaponType).toList();
        } else {
          types = currentState.tempWeaponTypes + [e.weaponType];
        }
        return currentState.copyWith.call(tempWeaponTypes: types);
      },
      searchChanged: (e) => _buildInitialState(
        search: e.search,
        weaponFilterType: currentState.weaponFilterType,
        rarity: currentState.rarity,
        sortDirectionType: currentState.sortDirectionType,
        weaponTypes: currentState.weaponTypes,
      ),
      applyFilterChanges: (_) => _buildInitialState(
        search: currentState.search,
        weaponFilterType: currentState.tempWeaponFilterType,
        rarity: currentState.tempRarity,
        sortDirectionType: currentState.tempSortDirectionType,
        weaponTypes: currentState.tempWeaponTypes,
      ),
      cancelChanges: (_) => currentState.copyWith.call(
        tempWeaponFilterType: currentState.weaponFilterType,
        tempRarity: currentState.rarity,
        tempSortDirectionType: currentState.sortDirectionType,
        tempWeaponTypes: currentState.weaponTypes,
      ),
    );

    yield s;
  }

  WeaponsState _buildInitialState({
    String search,
    List<WeaponType> weaponTypes = const [],
    int rarity = 0,
    WeaponFilterType weaponFilterType = WeaponFilterType.rarity,
    SortDirectionType sortDirectionType = SortDirectionType.asc,
  }) {
    final isLoaded = state is _LoadedState;
    var data = _genshinService.getWeaponsForCard();

    if (!isLoaded) {
      final selectedWeaponTypes = WeaponType.values.toList();
      _sortData(data, weaponFilterType, sortDirectionType);
      return WeaponsState.loaded(
        weapons: data,
        search: search,
        weaponTypes: selectedWeaponTypes,
        tempWeaponTypes: selectedWeaponTypes,
        rarity: rarity,
        tempRarity: rarity,
        weaponFilterType: weaponFilterType,
        tempWeaponFilterType: weaponFilterType,
        sortDirectionType: sortDirectionType,
        tempSortDirectionType: sortDirectionType,
      );
    }

    if (search != null && search.isNotEmpty) {
      data = data.where((el) => el.name.toLowerCase().contains(search.toLowerCase())).toList();
    }

    if (rarity > 0) {
      data = data.where((el) => el.rarity == rarity).toList();
    }

    if (weaponTypes.isNotEmpty) {
      data = data.where((el) => weaponTypes.contains(el.type)).toList();
    }

    _sortData(data, weaponFilterType, sortDirectionType);

    final s = currentState.copyWith.call(
      weapons: data,
      search: search,
      weaponTypes: weaponTypes,
      tempWeaponTypes: weaponTypes,
      rarity: rarity,
      tempRarity: rarity,
      weaponFilterType: weaponFilterType,
      tempWeaponFilterType: weaponFilterType,
      sortDirectionType: sortDirectionType,
      tempSortDirectionType: sortDirectionType,
    );
    return s;
  }

  void _sortData(
    List<WeaponCardModel> data,
    WeaponFilterType weaponFilterType,
    SortDirectionType sortDirectionType,
  ) {
    switch (weaponFilterType) {
      case WeaponFilterType.atk:
        if (sortDirectionType == SortDirectionType.asc) {
          data.sort((x, y) => x.baseAtk.compareTo(y.baseAtk));
        } else {
          data.sort((x, y) => y.baseAtk.compareTo(x.baseAtk));
        }
        break;
      case WeaponFilterType.name:
        if (sortDirectionType == SortDirectionType.asc) {
          data.sort((x, y) => x.name.compareTo(y.name));
        } else {
          data.sort((x, y) => y.name.compareTo(x.name));
        }
        break;

      case WeaponFilterType.rarity:
        if (sortDirectionType == SortDirectionType.asc) {
          data.sort((x, y) => x.rarity.compareTo(y.rarity));
        } else {
          data.sort((x, y) => y.rarity.compareTo(x.rarity));
        }
        break;
      default:
        break;
    }
  }
}
