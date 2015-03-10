--要塞
function c18781002.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c18781002.splimcon)
	e2:SetTarget(c18781002.splimit)
	c:RegisterEffect(e2)
    --destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(64332231,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetRange(LOCATION_SZONE+LOCATION_PZONE)
	e6:SetCountLimit(1,18781002)
	e6:SetCondition(c18781002.condition)
	e6:SetCost(c18781002.necost)
	e6:SetTarget(c18781002.destg)
	e6:SetOperation(c18781002.desop)
	c:RegisterEffect(e6)
end
function c18781002.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c18781002.splimit(e,c)
	return not c:IsSetCard(0xabb)
end
function c18781002.dfilter(c,atk)
	return c:IsFaceup() and c:IsDestructable() and c:IsDefenceBelow(2500)
end
function c18781002.ccfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6abb) and c:IsType(TYPE_XYZ)
end
function c18781002.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c18781002.ccfilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c18781002.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end	
function c18781002.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c18781002.ccfilter2,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil) and
	Duel.IsExistingMatchingCard(c18781002.dfilter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c187187029.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,nil)
end
function c18781002.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c18781002.ccfilter2,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)  then
		local sg1=Duel.GetMatchingGroup(c18781002.dfilter,tp,0,LOCATION_MZONE,nil)
		local sg2=Duel.Destroy(sg1,REASON_EFFECT)
end
end