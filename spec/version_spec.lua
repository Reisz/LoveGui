_G.love = {_version_major = 2, _version_minor = 3, _version_revision = 4}
local version = require "util.version"

describe("util.version", function()
  it("should be able to construct new instances", function()
    assert.are.same({1,2,3}, version{1,2,3})
    assert.has_no.error(function() version{1} end)
    assert.has_no.error(function() return version == version{1} end)
    assert.has_no.error(function() return version < version{1} end)
    assert.has_no.error(function() return version <= version{1} end)
    assert.has_no.error(function() return version > version{1} end)
    assert.has_no.error(function() return version >= version{1} end)
  end)
  it("should initially contain the current version", function()
    assert.are.same({major=2,minor=3,revision=4}, version)
  end)
  it("should be able to verify version equality", function()
    assert.is_true(version == version{2,3,4})
    assert.is_false(version == version{0,3,4})
    assert.is_false(version == version{2,0,4})
    assert.is_false(version == version{2,3,0})
    assert.is_false(version == version{0,0,4})
    assert.is_false(version == version{0,3,0})
    assert.is_false(version == version{2,0,0})
    assert.is_false(version == version{0,0,0})
  end)
  it("should be able to use lt", function()
    assert.is_false(version < version{1,0,0})
    assert.is_false(version < version{1,3,0})
    assert.is_false(version < version{1,3,4})
    assert.is_false(version < version{2,2,4})
    assert.is_false(version < version{2,3,3})
    assert.is_false(version < version{2,3,4})
    assert.is_true(version < version{3,0,0})
    assert.is_true(version < version{2,4,0})
    assert.is_true(version < version{3,0,5})
  end)
  it("should be able to use le", function()
    assert.is_false(version <= version{1,0,0})
    assert.is_false(version <= version{1,3,0})
    assert.is_false(version <= version{1,3,4})
    assert.is_false(version <= version{2,2,4})
    assert.is_false(version <= version{2,3,3})
    assert.is_true(version <= version{2,3,4})
    assert.is_true(version <= version{3,0,0})
    assert.is_true(version <= version{2,4,0})
    assert.is_true(version <= version{3,0,5})
  end)
end)
