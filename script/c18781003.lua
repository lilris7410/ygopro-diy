--軍團長
function c18781003.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95027497,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,18781003)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c18781003.tg1)
	e1:SetOperation(c18781003.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c18781003.cost)
	e4:SetTarget(c18781003.detg)
	e4:SetOperation(c18781003.deop)
	c:RegisterEffect(e4)
end
function c18781003.filter1(c)
	return c:IsSetCard(0x3abb) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c18781003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18781003.filter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c18781003.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18781003.filter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18781003.cfilter(c)
	return c:IsSetCard(0x3abb) and c:IsReleasable()
end
function c18781003.cfilter2(c)
	return c:IsSetCard(0x3abb) and c:IsReleasable() and c:IsType(TYPE_PENDULUM)
end
function c18781003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c18781003.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	if Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7) then 
	local g=Duel.SelectTarget(tp,c18781003.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
	else
	local g=Duel.SelectTarget(tp,c18781003.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.Release(g,REASON_COST)
	end
end
function c18781003.defilter(c)
	return c:IsSetCard(0x3abb) and c:IsType(TYPE_PENDULUM)
end
function c18781003.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18781003.defilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)<2 end
end
function c18781003.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c18781003.defilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end