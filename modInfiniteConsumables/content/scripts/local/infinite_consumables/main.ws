
function WIC_isItemInfinite(inventory: CInventoryComponent, item_id : SItemUniqueId): bool {
  return inventory.IsItemPotion(item_id)
      || inventory.IsItemOil(item_id);
}

/// Returns true when it should continue, returns false when the consumption
/// should be cancelled.
function WIC_setConsumableInfinite(inventory: CInventoryComponent, item_id : SItemUniqueId): bool {
  var cost: int;

  if (!WIC_isItemInfinite(inventory, item_id)) {
    return true;
  }

  cost = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('WICgeneral', 'WICconsumingCost'));
  cost *= inventory.GetItemQuality(item_id);
  if (inventory.GetMoney() < cost) {
		theSound.SoundEvent("gui_global_denied");

    return false;
  }

  inventory.RemoveMoney(cost);

  thePlayer.DisplayHudMessage(cost + " crowns spent");

  return true;
}

function WIC_requirementMultiplier(): int {
  return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('WICgeneral', 'WICrequirementMultiplier'));
}

function WIC_isRecipeForPotionOrOil(out recipe: SAlchemyRecipe): bool {
  return recipe.cookedItemType == EACIT_MutagenPotion
      || recipe.cookedItemType == EACIT_Potion
      || recipe.cookedItemType == EACIT_Oil;
}

function WIC_getAlchemyRequirementsMultiplier(out recipe: SAlchemyRecipe): int {
  if (WIC_isRecipeForPotionOrOil(recipe)) {
    return WIC_requirementMultiplier();
  }

  return 1;
}

function WIC_increaseAlchemyRequirements(out recipe: SAlchemyRecipe) {
  var dm : CDefinitionsManagerAccessor;
  var item_id : SItemUniqueId;
  var multiplier: int;
  var i: int;

  multiplier = WIC_requirementMultiplier();
  dm = theGame.GetDefinitionsManager();

  if (!WIC_isRecipeForPotionOrOil(recipe)) {
    return;
  }

  for (i = 0; i < recipe.requiredIngredients.Size(); i += 1) {

    // do not multiply potions or oils in recipes.
    if (dm.IsItemOil(recipe.requiredIngredients[i].itemName) || dm.IsItemPotion(recipe.requiredIngredients[i].itemName)) {
      continue;
    }

    if (recipe.requiredIngredients[i].quantity < 0) {
      continue;
    }

    recipe.requiredIngredients[i].quantity *= multiplier;
  }
}