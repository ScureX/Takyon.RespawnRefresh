global function RespawnRefreshInit

void function RespawnRefreshInit(){
    #if SERVER
    AddCallback_OnPlayerRespawned(OnPlayerSpawned)
    #endif
}

void function OnPlayerSpawned(entity player){
    #if SERVER
    if(!IsLobby()){
        // refresh all that stuff
        entity ordnance = player.GetOffhandWeapon(OFFHAND_ORDNANCE)
        entity ability = player.GetOffhandWeapon(OFFHAND_LEFT)

        // unsure if thats required but better safe than sorry
        if (player == null || !IsValid(player) || !IsValid(ordnance) || !IsValid(ability))
            return
        
        // tf2 works in mysterious ways, might be a charge weapon or sumn in there, i dont want any errors
        // recharge ordnance
        if(ordnance.IsChargeWeapon()) // is chargeable
            ordnance.SetWeaponChargeFraction(1.0)
        else if(ordnance.GetWeaponPrimaryClipCountMax() > 0) // is bullet // BAD FIX but idk how else
            ordnance.SetWeaponPrimaryClipCount(ordnance.GetWeaponPrimaryClipCountMax())

        // recharge ability
        if(ability.IsChargeWeapon()) // is chargeable
            ability.SetWeaponChargeFraction(1.0)
        else if(ability.GetWeaponPrimaryClipCountMax() > 0){ // is bullet // BAD FIX but idk how else
            // grapple goes here but doesnt recharge cause fuck you respawn
            if(ability.GetWeaponClassName() == "mp_ability_grapple"){
                player.SetSuitGrapplePower(1000) // dont know what max is, normally 100 but just makin sure this works even if you change shit
                return
            }
            ability.SetWeaponPrimaryClipCount(ability.GetWeaponPrimaryClipCountMax())
        }
    }
    #endif
}