package com.cardealership.modules.marketing.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.modules.marketing.entity.*;
import com.cardealership.modules.marketing.mapper.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class MarketingService {
    private final MktCampaignMapper campaignMapper;
    private final MktCouponMapper couponMapper;

    public Page<MktCampaign> pageCampaigns(int page, int size) {
        return campaignMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<MktCampaign>().orderByDesc(MktCampaign::getCreatedAt));
    }

    @Transactional
    public void saveCampaign(MktCampaign c) {
        if (c.getId() == null) campaignMapper.insert(c);
        else campaignMapper.updateById(c);
    }

    @Transactional
    public void deleteCampaign(Long id) { campaignMapper.deleteById(id); }

    public Page<MktCoupon> pageCoupons(int page, int size) {
        return couponMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<MktCoupon>().orderByDesc(MktCoupon::getCreatedAt));
    }

    @Transactional
    public void saveCoupon(MktCoupon c) {
        if (c.getId() == null) couponMapper.insert(c);
        else couponMapper.updateById(c);
    }

    @Transactional
    public void deleteCoupon(Long id) { couponMapper.deleteById(id); }
}
