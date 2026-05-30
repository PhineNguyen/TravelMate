package com.travelmate.backend.service;

import com.travelmate.backend.dto.TemplateItemDTO;
import java.util.List;

public interface TemplateItemService {
    TemplateItemDTO create(TemplateItemDTO dto);

    TemplateItemDTO update(TemplateItemDTO dto);

    TemplateItemDTO findById(Long id);

    List<TemplateItemDTO> listAll();

    void delete(Long id);
}
