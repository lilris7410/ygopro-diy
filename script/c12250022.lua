--Gosick·利维坦
function c12250022.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x4c9),1)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c12250022.regop)
	c:RegisterEffect(e1)
	--Negate summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(97836203,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCondition(c12250022.discon)
	e2:SetTarget(c12250022.distg)
	e2:SetOperation(c12250022.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(97836203,1))
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(97836203,2))
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	--destroy & damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_MSET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c12250022.con)
	e5:SetCost(c12250022.setcost)
	e5:SetTarget(c12250022.settg)
	e5:SetOperation(c12250022.setop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c12250022.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO)~=SUMMON_TYPE_SYNCHRO then return end
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(c12250022.tgvalue)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c12250022.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c12250022.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c12250022.tfilter(c,e,tp)
	return (c:IsSSetable() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsSetCard(0x598) or c:IsCode(9791914) or c:IsCode(58132856))) or (c:IsMSetable(true,nil) and c:IsType(TYPE_MONSTER))
end
function c12250022.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(122500220)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	e:GetHandler():RegisterFlagEffect(122500220,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c12250022.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_MSET) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_SSET) then
		if Duel.GetMatchingGroupCount(c12250022.tfilter,1-tp,LOCATION_HAND,0,nil,e,1-tp)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,0)) then
			local sc=Group.GetFirst(Duel.SelectMatchingCard(1-tp,c12250022.tfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp))
			if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
				Duel.SSet(1-tp,sc)
			elseif (sc:IsSetCard(0x598) or sc:IsCode(9791914) or sc:IsCode(58132856)) and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,1)) then
				Duel.SSet(1-tp,sc)
			else
				Duel.MSet(1-tp,sc,true,nil)
			end
			return
		end
	end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.NegateSummon(eg:GetFirst())
	Duel.Destroy(eg,REASON_EFFECT)
end
function c12250022.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c12250022.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(122500221)==0 end
	e:GetHandler():RegisterFlagEffect(122500221,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c12250022.filter(c,e,tp)
	return c:IsSetCard(0x4c9) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12250022.setfilter(c,e)
	return c:IsFacedown() and c:IsLocation(LOCATION_ONFIELD)
end
function c12250022.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12250022.setfilter,1,nil,nil) end
	Duel.SetTargetCard(eg)
end
function c12250022.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	if not eg:IsExists(c12250022.setfilter,1,nil,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local sc=eg:GetFirst()
	local mg=Group.CreateGroup()
	local m=0
	while sc do
		if sc:IsLocation(LOCATION_ONFIELD) and sc:IsRelateToEffect(e) and sc:IsFacedown() then
			mg:AddCard(sc)
			if (res==0 and sc:IsType(TYPE_MONSTER)) or (res==1 and sc:IsType(TYPE_SPELL)) or (res==2 and sc:IsType(TYPE_TRAP)) then m=m+1 end
		end
		sc=eg:GetNext()
	end
	Duel.ConfirmCards(tp,mg)
	if m~=0 then
		--battle target
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
end