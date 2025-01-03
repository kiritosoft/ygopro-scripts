--ジェム・マーチャント
---@param c Card
function c53408006.initial_effect(c)
	--atk,def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(53408006,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c53408006.condition)
	e1:SetCost(c53408006.cost)
	e1:SetOperation(c53408006.operation)
	c:RegisterEffect(e1)
end
function c53408006.filter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_NORMAL)
end
function c53408006.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:IsControler(tp) and c53408006.filter(a) and a:IsRelateToBattle())
		or (d and d:IsControler(tp) and d:IsFaceup() and c53408006.filter(d) and d:IsRelateToBattle())
end
function c53408006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c53408006.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(1000)
	a:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	a:RegisterEffect(e2)
end
