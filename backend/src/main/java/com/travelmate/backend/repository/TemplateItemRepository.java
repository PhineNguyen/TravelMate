package com.travelmate.backend.repository;

import java.util.List;

import com.travelmate.backend.entity.TemplateItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TemplateItemRepository extends JpaRepository<TemplateItem, Long> {

    List<TemplateItem> findByTemplateId(Long templateId);

    List<TemplateItem> findByTemplateIdOrderByDayNumberAscOrderIndexAsc(Long templateId);

    List<TemplateItem> findByTemplateIdAndDayNumberOrderByOrderIndexAsc(Long templateId, Integer dayNumber);

    List<TemplateItem> findByPlaceId(Long placeId);

    boolean existsByTemplateIdAndDayNumberAndOrderIndex(Long templateId, Integer dayNumber, Integer orderIndex);

}
