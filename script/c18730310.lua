--吸血鬼
function c18730310.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17393207,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,18730310)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c18730310.hspcost)
	e1:SetTarget(c18730310.target)
	e1:SetOperation(c18730310.activate)
	c:RegisterEffect(e1)
	--ritual material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	c:RegisterEffect(e1)
	--become material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c18730310.condition1)
	e2:SetOperation(c18730310.operation1)
	c:RegisterEffect(e2)
end
function c18730310.dfilter(c)
	return c:IsAbleToGraveAsCost()
end
function c18730310.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18730310.dfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18730310.dfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c18730310.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c18730310.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c18730310.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18730310.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48976825,0))
	local g=Duel.SelectTarget(tp,c18730310.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c18730310.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end
function c18730310.condition1(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and re:GetHandler():IsSetCard(0xabb)
end
function c18730310.operation1(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	if rc:GetFlagEffect(18730310)==0 then
		--cannot special summon
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(18730310,0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetValue(c18730310.aclimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetAbsoluteRange(rp,0,1)
		rc:RegisterEffect(e1)
		rc:RegisterFlagEffect(18730310,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c18730310.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_MZONE) and not re:GetHandler():IsImmuneToEffect(e)
end