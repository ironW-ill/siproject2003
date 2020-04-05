package com.example.demo.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.dto.LawMakerDto;
import com.example.demo.dto.LoginDto;

@Mapper
public interface AjaxDao {

	public int login(String id, String pwd) throws Exception;
}
