package com.example.demo.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.dto.LawMakerDto;
import com.example.demo.dto.LoginDto;

@Mapper
public interface InfoDao {

	public int test() throws Exception;

	public ArrayList<LawMakerDto> selectLawmaker() throws Exception;

	public int login(LoginDto param) throws Exception;
}
