﻿using System.Collections.Generic;
using System.Security.Claims;
using System.Web.Http;
using API.Filters;
using API.Models;

namespace API.Controllers
{
    [Route]
    [IdentityAPI] // Enable authentication via an ASP.NET Identity user name and password
    [Authorize] // Require some form of authentication
    public class HomeController : ApiController
    {
        public IHttpActionResult Get()
        {
            HomeModel model = new HomeModel
            {
                UserName = User.Identity.Name
            };

            ClaimsIdentity identity = User.Identity as ClaimsIdentity;

            if (identity != null)
            {
                List<ClaimModel> claims = new List<ClaimModel>();

                foreach (Claim claim in identity.Claims)
                {
                    //if(claim.Type == "hasRegistered")
                    claims.Add(new ClaimModel
                    {
                        Type = claim.Type,
                        Value = claim.Value
                    });
                }

                model.Claims = claims;
            }

            return Json(model);
        }
    }
}