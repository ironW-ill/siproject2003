package com.example.demo.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.dto.LawMakerDto;

@Mapper
public interface InfoDao {

	public int test() throws Exception;

	public ArrayList<LawMakerDto> selectLawmaker() throws Exception;
}
