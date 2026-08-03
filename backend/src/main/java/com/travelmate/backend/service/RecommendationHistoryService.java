package com.travelmate.backend.service;

import com.travelmate.backend.dto.RecommendationHistoryDTO;
import java.util.List;

public interface RecommendationHistoryService {
    RecommendationHistoryDTO create(RecommendationHistoryDTO dto);

    RecommendationHistoryDTO update(RecommendationHistoryDTO dto);

    RecommendationHistoryDTO findById(Long id);

    List<RecommendationHistoryDTO> listAll();

    void delete(Long id);
}
