import 'package:genshindb/domain/enums/enums.dart';
import 'package:genshindb/domain/models/models.dart';

abstract class GenshinService {
  Future<void> init(AppLanguageType languageType);
  Future<void> initCharacters();
  Future<void> initWeapons();
  Future<void> initArtifacts();
  Future<void> initMaterials();
  Future<void> initElements();
  Future<void> initGameCodes();
  Future<void> initTranslations(AppLanguageType languageType);

  List<CharacterCardModel> getCharactersForCard();
  CharacterFileModel getCharacter(String key);
  CharacterFileModel getCharacterByImg(String img);
  List<CharacterFileModel> getCharactersForBirthday(DateTime date);
  List<TierListRowModel> getDefaultCharacterTierList(List<int> colors);

  List<WeaponCardModel> getWeaponsForCard();
  WeaponCardModel getWeaponForCardByImg(String image);
  WeaponFileModel getWeapon(String key);
  WeaponFileModel getWeaponByImg(String img);
  List<String> getCharactersImgUsingWeapon(String key);

  List<ArtifactCardModel> getArtifactsForCard();
  ArtifactCardModel getArtifactForCardByImg(String image);
  ArtifactFileModel getArtifact(String key);
  List<String> getCharactersImgUsingArtifact(String key);

  TranslationArtifactFile getArtifactTranslation(String key);
  TranslationCharacterFile getCharacterTranslation(String key);
  TranslationWeaponFile getWeaponTranslation(String key);

  List<TodayCharAscensionMaterialsModel> getCharacterAscensionMaterials(int day);
  List<TodayWeaponAscensionMaterialModel> getWeaponAscensionMaterials(int day);

  List<ElementCardModel> getElementDebuffs();
  List<ElementReactionCardModel> getElementReactions();
  List<ElementReactionCardModel> getElementResonances();

  List<MaterialCardModel> getAllMaterials();
  MaterialFileModel getMaterialByImage(String image);
  List<MaterialFileModel> getMaterials(MaterialType type);

  int getServerDay(AppServerResetTimeType type);

  List<GameCodeFileModel> getAllGameCodes();
}
