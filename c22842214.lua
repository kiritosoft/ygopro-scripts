--シー・ランサー
function c22842214.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22842214,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c22842214.eqtg)
	e1:SetOperation(c22842214.eqop)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c22842214.desreptg)
	e2:SetOperation(c22842214.desrepop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c22842214.atcon)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
end
function c22842214.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH+RACE_AQUA+RACE_SEASERPENT) and not c:IsForbidden()
end
function c22842214.opfilter(c,e)
	return c:IsRelateToEffect(e) and c22842214.filter(c)
end
function c22842214.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c22842214.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c22842214.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local fc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22842214.filter,tp,LOCATION_REMOVED,0,1,fc,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
end
function c22842214.eqlimit(e,c)
	return e:GetOwner()==c
end
function c22842214.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c22842214.opfilter,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local tg=Group.CreateGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if ft>=g:GetCount() then
			tg:Merge(g)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			tg:Merge(g:Select(tp,ft,ft,nil))
		end
	end
	g:Sub(tg)
	local tc=tg:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,false,true)
		tc:RegisterFlagEffect(22842214,RESET_EVENT+RESETS_STANDARD,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c22842214.eqlimit)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
	Duel.EquipComplete()
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_RULE)
	end
end
function c22842214.eqfilter(c,ec)
	return c:GetFlagEffect(22842214)~=0 and c:IsHasCardTarget(ec)
end
function c22842214.repfilter(c,e,ec)
	return c22842214.eqfilter(c,ec) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c22842214.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and Duel.IsExistingMatchingCard(c22842214.repfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,c) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tc=Duel.SelectMatchingCard(tp,c22842214.repfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,c):GetFirst()
		e:SetLabelObject(tc)
		tc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c22842214.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
function c22842214.atcon(e)
	return Duel.IsExistingMatchingCard(c22842214.eqfilter,e:GetHandlerPlayer(),LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler())
end
